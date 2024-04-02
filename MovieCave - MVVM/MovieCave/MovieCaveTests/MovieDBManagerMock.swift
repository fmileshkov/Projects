//
//  MovieDBManagerMock.swift
//  MovieCaveTests
//
//  Created by Admin on 16.11.23.
//

import Foundation
@testable import MovieCave

enum MockMovieDBManagerType {
    case happy
    case sad
}

class MovieDBManagerMock: MovieDBServiceProtocol {

    var succesCase: MockMovieDBManagerType
    var operateWithAPIType: MediaType?
    var moviesList: MoviesList
    var operateWithAPIKey: String?
    var operateWithAPIPage: Int?
    var operateWithAPIOperationType: APIOperations?
    var operateWithAPIHTTPMethod: HTTPMethod?
    
    var apiCallTVSeriesResult: TVSeriesData?
    var apiCallMoviesResult: MoviesModel?
    var apiCallError: String?
    var mediaDetails: MediaDetails?
    var mediaVideos: MediaVideos?
    var mediaCast: MediaCast?
    
    var fetchRequestTokenCalled = false
     
    init(succesCase: MockMovieDBManagerType, moviesList: MoviesList) {
        self.succesCase = succesCase
        self.moviesList = moviesList
    }
    
    func operateWithAPI<R: Codable>(type: MediaType, key: String, page: Int, operationType: APIOperations, httpMethod: HTTPMethod, completion: @escaping (Result<R, MovieDBErrors>) -> Void) {

        operateWithAPIType = type
        operateWithAPIPage = page
        operateWithAPIOperationType = operationType
        operateWithAPIHTTPMethod = httpMethod
        
        switch type {
        case .tvSeries:
            if R.self == TVSeriesData.self {
                mockTVSeriesAPICall(page: page, key: key, completion: completion)
            } else if R.self == TVSeriesDetailsData.self {
                mockTVSeriesAPICall(page: page, key: key, completion: completion)
            } else if R.self == MediaCastDecoder.self {
                mockTVSeriesAPICall(page: page, key: key, completion: completion)
            } else if R.self == MediaVideosDecoder.self {
                mockTVSeriesAPICall(page: page, key: key, completion: completion)
            }
        case .movies:
            if R.self == MoviesData.self {
                mockMoviesAPICall(page: page, key: key, completion: completion)
            } else if R.self == MovieDetailsData.self {
                mockMoviesAPICall(page: page, key: key, completion: completion)
            } else if R.self == MediaCastDecoder.self {
                mockMoviesAPICall(page: page, key: key, completion: completion)
            } else if R.self == MediaVideosDecoder.self {
                mockMoviesAPICall(page: page, key: key, completion: completion)
            }
        }

    }
    
    private func mockMoviesAPICall<R: Codable>(page: Int, key: String, completion: @escaping (Result<R, MovieDBErrors>) -> Void) {
        guard page == 1 else {
            operateWithAPIPage = page
            completion(.failure(.badData))
             return
        }

        var movies: [MoviesData] = []
        let results = [MovieResults(id: 10,
                                    originalTitle: key,
                                    overview: "COLD",
                                    genreIds: [1],
                                    posterPath: "POSTER")]
        
        
        movies.append(MoviesData(page: page, totalPages: 100, results: results))
        
        switch succesCase {
        case .sad:
            operateWithAPIKey = ""
            let error = MovieDBErrors.badData.localizedDescription
            completion(.failure(.badData))
            apiCallError = error
        case .happy:
            switch key {
            case "\(10)":
                operateWithAPIKey = key
                createMovieArray(moviesFromApi: movies) { [weak self] model in
                    self?.apiCallMoviesResult = model.last
                }
                
                if R.self == MovieDetailsData.self {
                    let details: MovieDetailsData = MovieDetailsData(genres: [],
                                                                     id: 10,
                                                                     firstAirDate: "10.10",
                                                                     runtime: 20,
                                                                     voteAverage: 8,
                                                                     voteCount: 50,
                                                                     backdropPath: "BACK POSTER",
                                                                     posterPath: "BIG POSTER",
                                                                     name: "TITLE",
                                                                     overview: "OVERVIEW")
                    mediaDetails = MediaDetails(title: details.name,
                                                overview: details.overview,
                                                id: details.id,
                                                poster: details.posterPath ?? "POSTER",
                                                bigPoster: details.backdropPath ?? "POSTTER",
                                                avrgVote: "\(details.voteAverage)",
                                                releaseDate: details.firstAirDate,
                                                gernes: details.genres.map{$0.name})
                    completion(.success(details as! R))
                    
                } else if R.self == MediaVideosDecoder.self {
                    let videos: MediaVideosDecoder = MediaVideosDecoder(results: [MediaVideosDecoder.VideoResults(name: "MOVIE", key: "KEY", site: "MYSITE", type: "Trailer", id: "\(15)")])
                    mediaVideos = MediaVideos(key: videos.results[0].key, name: videos.results[0].name)
                    completion(.success(videos as! R))
                    
                } else if R.self == MediaCastDecoder.self {
                    let cast: MediaCastDecoder = MediaCastDecoder(cast: [MediaCastDecoder.CastDetails(name: "JOHN")])
                    mediaCast = MediaCast(name: cast.cast[0].name)
                    completion(.success(cast as! R))
                }
                
            case "popular":
                operateWithAPIKey = "Most popular"
                createMovieArray(moviesFromApi: movies) { [weak self] model in
                    self?.apiCallMoviesResult = model.last
                }
                completion(.success(movies.last as! R))
            case "upcoming":
                operateWithAPIKey = "Upcoming"
                createMovieArray(moviesFromApi: movies) { [weak self] model in
                    self?.apiCallMoviesResult = model.last
                }
                completion(.success(movies.last as! R))
            case "top_rated":
                operateWithAPIKey = "Top rated"
                createMovieArray(moviesFromApi: movies) { [weak self] model in
                    self?.apiCallMoviesResult = model.last
                }
                completion(.success(movies.last as! R))
            case "now_playing":
                operateWithAPIKey = "Newest"
                createMovieArray(moviesFromApi: movies) { [weak self] model in
                    self?.apiCallMoviesResult = model.last
                }
                completion(.success(movies.last as! R))
            default:
                operateWithAPIKey = key
                createMovieArray(moviesFromApi: movies) { [weak self] model in
                    self?.apiCallMoviesResult = model.last
                }
                completion(.success(movies.last as! R))
            }
        }
    }
    
    private func mockTVSeriesAPICall<R: Codable>(page: Int, key: String, completion: @escaping (Result<R, MovieDBErrors>) -> Void) {
        guard page == 1 else {
            operateWithAPIPage = page
            completion(.failure(.badData))
             return
        }
        
        let results = [TVSeriesResults(id: 10,
                                      name: key,
                                      overview: "HOT",
                                       genreIds: [1])]
        let data = TVSeriesData(page: page, totalPages: 100, results: results)
        
        switch succesCase {
        case .sad:
            operateWithAPIKey = ""
            let error = MovieDBErrors.badData.localizedDescription
            completion(.failure(.badData))
            apiCallError = error
        case .happy:
            switch key {
            case "\(10)":
                operateWithAPIKey = key
                apiCallTVSeriesResult = data
                if R.self == TVSeriesDetailsData.self {
                    let details: TVSeriesDetailsData = TVSeriesDetailsData(genres: [],
                                                                           id: 25,
                                                                           firstAirDate: "25.10",
                                                                           name: "SERIES NAME",
                                                                           backdropPath: "BACK POSTER",
                                                                           posterPath: "POSTER BIG",
                                                                           voteAverage: 9,
                                                                           voteCount: 59,
                                                                           overview: "OOOVER")
                    mediaDetails = MediaDetails(title: details.name,
                                                overview: details.overview,
                                                id: details.id,
                                                poster: details.posterPath ?? "POSTER",
                                                bigPoster: details.backdropPath ?? "POSTTER",
                                                avrgVote: "\(details.voteAverage)",
                                                releaseDate: details.firstAirDate,
                                                gernes: details.genres.map{$0.name})
                    completion(.success(details as! R))
                } else if R.self == MediaVideosDecoder.self {
                    let videos: MediaVideosDecoder = MediaVideosDecoder(results: [MediaVideosDecoder.VideoResults(name: "VIDEO", key: "VIDEO", site: "MY", type: "Trailer", id: "\(22)")])
                    mediaVideos = MediaVideos(key: videos.results[0].key, name: videos.results[0].name)
                    completion(.success(videos as! R))
                } else if R.self == MediaCastDecoder.self {
                    let cast: MediaCastDecoder = MediaCastDecoder(cast: [MediaCastDecoder.CastDetails(name: "CASTER")])
                    mediaCast = MediaCast(name: cast.cast[0].name)
                    completion(.success(cast as! R))
                }
            case "popular":
                operateWithAPIKey = "Most popular"
                apiCallTVSeriesResult = data
                completion(.success(data as! R))
            case "airing_today":
                operateWithAPIKey = "Airing today"
                completion(.success(data as! R))
            case "top_rated":
                operateWithAPIKey = "Top rated"
                completion(.success(data as! R))
            case "on_the_air":
                operateWithAPIKey = "On the air"
                completion(.success(data as! R))
            default:
                operateWithAPIKey = key
                completion(.success(data as! R))
                apiCallTVSeriesResult = data
            }
        }
    }
    
    
    func movieArrayCreation(operationType: MovieCave.APIOperations, with key: String, for list: MovieCave.MoviesList, page: Int, completion: @escaping (Result<MovieCave.MoviesModel, MovieCave.MovieDBErrors>) -> Void) {
        
        operateWithAPI(type: .movies, key: key, page: page, operationType: operationType, httpMethod: .get) { [weak self] (result: Result<MoviesData, MovieDBErrors>) in
            
            switch result {
            case .success(let movies):
                switch list {
                case .allMovies:
                    completion(.success(
                        MoviesModel(page: movies.page,
                                    totalPages: movies.totalPages,
                                    modelResults: [MovieModelResults(movieResults: movies.results[0], isFavorite: false)])))
                case .favorites:
                    completion(.success(
                        MoviesModel(page: movies.page,
                                    totalPages: movies.totalPages,
                                    modelResults: [MovieModelResults(movieResults: movies.results[0], isFavorite: true)])))
                }
                               
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func tvSeriesArrayCreation(with key: String, on page: Int, operationType: MovieCave.APIOperations, completion: @escaping (Result<MovieCave.TVSeriesData, MovieCave.MovieDBErrors>) -> Void) {
        
        operateWithAPI(type: .tvSeries, key: key, page: page, operationType: operationType, httpMethod: .get) { [weak self] (result: Result<TVSeriesData, MovieDBErrors>) in
            
            switch result {
            case .success(let series):
                completion(.success(TVSeriesData(page: series.page, totalPages: series.totalPages, results: series.results)))
            case .failure(let error):
                guard self?.succesCase == .sad else { return }
                
                completion(.failure(error))
            }
        }
    }

    func createMovieArray(moviesFromApi: [MoviesData], completion: @escaping ([MoviesModel]) -> Void) {
        var movieWrappers = [MoviesModel]()

        switch moviesList {
        case .allMovies:
            moviesFromApi.forEach { result in
                let movie = MoviesModel(page: result.page,
                                        totalPages: result.totalPages,
                                        modelResults: [MovieModelResults(movieResults: result.results[0], isFavorite: false)])
                movieWrappers.append(movie)
            }
            completion(movieWrappers)
        case .favorites:
            fetchFavoriteMovies(moviesFromApi: moviesFromApi) { completion($0) }
        }
    }
    
    func fetchFavoriteMovies(moviesFromApi: [MoviesData], completion: @escaping ([MoviesModel]) -> Void) {
        var favoriteMovies = [MoviesModel]()
        
        moviesFromApi.forEach { results in
            let favoriteMovie = MoviesModel(page: results.page, totalPages: results.totalPages,
                                            modelResults: [MovieModelResults(movieResults: results.results[0], isFavorite: true)])
            favoriteMovies.append(favoriteMovie)
        }
        completion(favoriteMovies)
    }

    func manageFavoritesMovies(with movieID: Int, for operation: Favorites) {
        switch succesCase {
        case .happy:
            guard let movie = apiCallMoviesResult?.modelResults.first(where: { $0.movieResults.id == movieID }) else { return }
    
            let movieModel: MoviesModel?
            
            switch operation {
            case .removeFromFavorites:
                movieModel = MoviesModel(page: 1, totalPages: 15, modelResults:
                                            [MovieModelResults(movieResults: movie.movieResults, isFavorite: false)])
            case .addToFavorites:
                movieModel = MoviesModel(page: 1, totalPages: 15, modelResults:
                                            [MovieModelResults(movieResults: movie.movieResults, isFavorite: true)])
            }
            
            apiCallMoviesResult = movieModel
        case .sad:
            apiCallMoviesResult = nil
        }
    }
    
    func fetchRequestToken() {
        switch succesCase {
        case .happy:
            fetchRequestTokenCalled = true
        case .sad:
            fetchRequestTokenCalled = false
        }
    }
    
}
