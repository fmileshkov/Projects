//
//  MovieDBService.swift
//  MovieCave
//
//  Created by Admin on 20.09.23.
//

import UIKit

protocol MovieDBServiceProtocol {
    
    /// Performs an operation with the MovieDB API.
    /// - Parameters:
    ///   - type: The type of media (e.g., movie or TV show) to perform the operation on.
    ///   - key: The API key for the url.
    ///   - page: The page number for paginated results.
    ///   - operationType: The type of operation to perform (e.g., fetch popular movies, search TV shows).
    ///   - httpMethod: The HTTP method for the request.
    ///   - completion: A closure that is called with either the response data or an error.
    func operateWithAPI<R: Codable>(type: MediaType,
                                    key: String,
                                    page: Int,
                                    operationType: APIOperations,
                                    httpMethod: HTTPMethod,
                                    completion: @escaping (Result<R, MovieDBErrors>) -> Void)

    /// Manages favorite movies.
    /// This method allows you to manage favorite movies for a specific movie identified by `movieID`.
    /// The `operation` parameter specifies the type of operation to perform on the favorite movie, such as adding or removing it from favorites.
    /// - Parameters:
    ///   - movieID: The ID of the movie to manage as a favorite.
    ///   - operation: The type of operation to perform on the favorite movie.
    func manageFavoritesMovies(with movieID: Int, for operation: Favorites)
    
    /// Fetches a request token.
    /// This method is used to fetch a request token from the server.
    /// After fetching the request token, it can be used in subsequent API calls.
    func fetchRequestToken()
    
    /// Creates an array of movies based on the specified operation type, key, movie list, and page number.
    /// - Parameters:
    ///   - operationType: The type of API operation to perform.
    ///   - key: The API key used for authentication.
    ///   - list: The movie list to retrieve data from.
    ///   - page: The page number of the results to fetch.
    ///   - completion: A closure that is called with the result of the operation, containing an array of MoviesModel on success or an error on failure.
    func movieArrayCreation(operationType: APIOperations,with key: String, for list: MoviesList, page: Int, completion: @escaping (Result<MoviesModel, MovieDBErrors>) -> Void)
    
    /// Creates an array of TV series based on the specified key, page number, and operation type.
    /// - Parameters:
    ///   - key: The API key used for authentication.
    ///   - page: The page number of the results to fetch.
    ///   - operationType: The type of API operation to perform.
    ///   - completion: A closure that is called with the result of the operation, containing an array of TVSeriesResults on success or an error on failure.
    func tvSeriesArrayCreation(with key: String, on page: Int, operationType: APIOperations, completion: @escaping (Result<TVSeriesData, MovieDBErrors>) -> Void)
}
class MovieDBService: MovieDBServiceProtocol {

    //MARK: - Generic API call method
    func operateWithAPI<R: Codable>(type: MediaType,
                                    key: String,
                                    page: Int,
                                    operationType: APIOperations,
                                    httpMethod: HTTPMethod,
                                    completion: @escaping (Result<R, MovieDBErrors>) -> Void) {
        guard let safeURL = operationType.chooseOperation(for: type, key: key, page: page).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: safeURL) else { return }
        
        let request = NSMutableURLRequest(url: url,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        
        request.httpMethod = httpMethod.chooseMethod()
        request.allHTTPHeaderFields = Links.headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { [weak self] data, response, error in
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200,
                  error == nil,
                  let safeData = data else {
                completion(.failure(.badResponse))
                return
            }
            
            guard let successData = self?.parseJSON(safeData, as: operationType.chooseModel()) as? R else { return }
            
            completion(.success(successData))
        }
        dataTask.resume()
    }
    
    //MARK: - TVSeries
    func tvSeriesArrayCreation(with key: String, on page: Int, operationType: APIOperations, completion: @escaping (Result<TVSeriesData, MovieDBErrors>) -> Void) {
        operateWithAPI(type: .tvSeries, key: key, page: page, operationType: operationType, httpMethod: .get) { [weak self] (result: Result<TVSeriesData, MovieDBErrors>) in
            
            switch result {
            case .success(let series):
                completion(.success(series))
            case .failure(_):
                completion(.failure(.badResponse))
            }
        }
    }
    
    //MARK: - Movies
    func movieArrayCreation(operationType: APIOperations,with key: String, for list: MoviesList, page: Int, completion: @escaping (Result<MoviesModel, MovieDBErrors>) -> Void) {

        operateWithAPI(type: .movies, key: key, page: page, operationType: operationType, httpMethod: .get) { [weak self] (result: Result<MoviesData, MovieDBErrors>) in
            guard let self else { return }

            switch result {
            case .success(let movies):
                self.fetchFavoriteMovies { favorites in
                    switch list {
                    case .allMovies:
                        completion(.success(self.createMovieWrappers(movies: movies, favorites: favorites)))
                    case .favorites:
                        completion(.success(self.createMovieWrappers(movies: movies, favorites: favorites, onlyFavorites: true)))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func fetchFavoriteMovies(completion: @escaping (FavoriteList) -> Void) {
        isMovieFavorite { favorites in
            completion(favorites)
        }
    }
    
    private func createMovieWrappers(movies: MoviesData, favorites: FavoriteList, onlyFavorites: Bool = false) -> MoviesModel {
        var modelResults: [MovieModelResults] = []

        if onlyFavorites {
            movies.results.forEach { movie in
                guard favorites.items.contains(where: { $0.id == movie.id }) else { return }
                
                modelResults.append(MovieModelResults(movieResults: movie, isFavorite: true))
            }
        } else {
            movies.results.forEach { movie in
                let isFavorite = favorites.items.contains { $0.id == movie.id }
                modelResults.append(MovieModelResults(movieResults: movie, isFavorite: isFavorite))
            }
        }
        
        return MoviesModel(page: movies.page, totalPages: movies.totalPages, modelResults: modelResults)
    }
    
    private func isMovieFavorite(completion: @escaping (FavoriteList) -> Void) {
        guard let url = URL(string: "https://api.themoviedb.org/3/list/\(Links.favoritesListID)?language=en-US") else { return }
        
        let headers = [
            "accept": "application/json",
            "Authorization": Links.staticBearer
        ]
        
        let request = NSMutableURLRequest(url: url,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            guard error == nil,
                  let safeData = data else {
                print(error as Any)
                return
            }
            
            if let favorites: FavoriteList = self.parseJSONAuth(safeData) {
                completion(favorites)
            }
        }
        
        task.resume()
    }
    
    func manageFavoritesMovies(with movieID: Int, for operation: Favorites) {
        guard let url = URL(string: "https://api.themoviedb.org/3/list/\(Links.favoritesListID)/\(operation.operationType())") else { return }
        
        let headers = [
            "accept": "application/json",
            "content-type": "application/json",
            "Authorization": Links.staticBearer
        ]
        
        let request = NSMutableURLRequest(url: url,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        let parameters = ["media_id": movieID] as [String : Any]
        
        do {
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            request.httpBody = postData as Data
        } catch {
            print("Error catching postData form parameters")
        }
        
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { data, response, error in
            if (error != nil) {
                print(error as Any)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print("SUCCESS REMOVING MOVIE FROM LIST")
            }
        }
        
        dataTask.resume()
    }
    
    //MARK: - AUTH REQUESTS
    func fetchSuccessToken(reqToken: String) {
        let headers = [
            "accept": "application/json",
            "content-type": "application/json",
            "Authorization": Links.staticBearer
        ]
        
        let parameters = ["request_token": reqToken]
        
        guard let url = URL(string: "https://api.themoviedb.org/4/auth/access_token") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters)
            request.httpBody = jsonData
        } catch {
            print("Error serializing JSON: \(error)")
            return
        }
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200,
                  error == nil,
                  let safeData = data else {
                print("Invalid response or Error")
                return
            }
            
            if let _: UserAccessData = self.parseJSONAuth(safeData) {
                
            }
        }
        
        dataTask.resume()
    }
    
    func fetchRequestToken() {
        let headers = [
            "accept": "application/json",
            "content-type": "application/json",
            "Authorization": Links.staticBearer
        ]
        
        let parameters = ["redirect_to": "https://www.themoviedb.org/"]
        
        guard let url = URL(string: "https://api.themoviedb.org/4/auth/request_token") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters)
            request.httpBody = jsonData
        } catch {
            print("Error serializing JSON: \(error)")
            return
        }
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                  let safeData = data else {
                print("Error in API response")
                return
            }
            
            if let userModel: UserRequestData = self.parseJSONAuth(safeData) {
                self.authRequestToken(with: Links.requestAuthLink, with: userModel.requestToken)
            }
        }
        
        dataTask.resume()
    }
    
    private func authRequestToken(with url: String, with requestToken: String) {
        guard let url = URL(string: "\(url)\(requestToken)") else { return }
        
        DispatchQueue.main.async {
            UIApplication.shared.open(url)
        }
        UIApplication.shared.open(url, options: [:]) { success in
            if success {
                print("URL opened successfully")
            } else {
                print("Failed to open URL")
            }
        }
        
    }
    
    private func parseJSONAuth<T: Codable>(_ data: Data) -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            let decodedData = try decoder.decode(T.self, from: data)
            return decodedData
            
        } catch {
            print("Error parsing JSON: \(error)")
            return nil
        }
    }
    
    private func parseJSON<T: Codable>(_ data: Data, as type: T.Type) -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            let decodedData = try decoder.decode(T.self, from: data)
            return decodedData
            
        } catch {
            print("Error parsing JSON: \(error)")
            return nil
        }
    }
    
}
