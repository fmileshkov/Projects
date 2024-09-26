//
//  MovieDBServiceManegment.swift
//  MovieCave
//
//  Created by Admin on 5.11.23.
//

import Foundation

struct Operations {
    typealias ModelType = Codable
    
    enum Movies {
        case fetchMovies
        case fetchMovieDetails
        case fetchMovieCast
        case fetchMovieVideos
        case searchMovieByTitle
        
        func chooseModel() -> ModelType.Type {
            switch self {
                
            case .fetchMovies:
                return MoviesData.self
            case .fetchMovieDetails:
                return MovieDetailsData.self
            case .fetchMovieCast:
                return MediaCastDecoder.self
            case .fetchMovieVideos:
                return MediaVideosDecoder.self
            case .searchMovieByTitle:
                return MoviesData.self
            }
        }
        
        func chooseOperation(key: String) -> String {
            switch self {
                
            case .fetchMovies:
                return "https://api.themoviedb.org/3/movie/\(key)?language=en-US&page=1"
            case .fetchMovieDetails:
                return "https://api.themoviedb.org/3/movie/\(key)?language=en-US"
            case .fetchMovieCast:
                return "https://api.themoviedb.org/3/movie/\(key)/credits?language=en-US"
            case .fetchMovieVideos:
                return "https://api.themoviedb.org/3/movie/\(key)/videos?language=en-US"
            case .searchMovieByTitle:
                return "https://api.themoviedb.org/3/search/movie?query=\(key)&include_adult=false&language=en-US&page=1"
            }
        }
    }
    
    enum TVSeries {
        case fetchTVSeries
        case fetchSeriesDetails
        case fetchSeriesCast
        case fetchSeriesVideos
        case searchSeriesByTitle
        
        func chooseModel() -> ModelType.Type {
            switch self {
                
            case .fetchTVSeries:
                return TVSeriesData.self
            case .fetchSeriesDetails:
                return TVSeriesDetailsData.self
            case .fetchSeriesCast:
                return MediaCastDecoder.self
            case .fetchSeriesVideos:
                return MediaVideosDecoder.self
            case .searchSeriesByTitle:
                return TVSeriesData.self
            }
        }
        
        func chooseOperation(key: String) -> String {
            switch self {
                
            case .fetchTVSeries:
                return "https://api.themoviedb.org/3/tv/\(key)?language=en-US&page=1"
            case .fetchSeriesDetails:
                return "https://api.themoviedb.org/3/tv/\(key)?language=en-US"
            case .fetchSeriesCast:
                return "https://api.themoviedb.org/3/tv/\(key)/credits?language=en-US"
            case .fetchSeriesVideos:
                return "https://api.themoviedb.org/3/tv/\(key)/videos?language=en-US"
            case .searchSeriesByTitle:
                return "https://api.themoviedb.org/3/search/tv?query=\(key)&include_adult=false&language=en-US&page=1"
            }
        }
    }
    
}

struct Links {
    static let reqUrl = "https://api.themoviedb.org/4/auth/"
    static var reqToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ2ZXJzaW9uIjoxLCJzdWIiOiI2NTA4ODE1NjQyZDhhNTAwYzRmY2U4M2MiLCJuYmYiOjE2OTUyMTk0NDEsImF1ZCI6ImI3MWE4ZjNjMWQzM2EyNGE2ZTliNmQwNmI4ZjRmMjQ1IiwianRpIjoiNjcwOTUyMCIsInNjb3BlcyI6WyJhcGlfcmVhZCIsImFwaV93cml0ZSJdfQ.9WeB_NZg5zCXVUHKDhDlbJDw5_NYUgDgrg1eRd62VP0"
    static let staticBearer: String = "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiNzFhOGYzYzFkMzNhMjRhNmU5YjZkMDZiOGY0ZjI0NSIsInN1YiI6IjY1MDg4MTU2NDJkOGE1MDBjNGZjZTgzYyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.NBCSXvettdCw3cM5hrS3jvDDyAooTRPHv58JEEfuP5I"
    static let requestAuthLink = "https://www.themoviedb.org/auth/access?request_token="
    static let favoritesListID = "8272451"
    
    static var youTubeEmbedURL: (String) -> String {
        get {
            return { videoID in
                return "https://www.youtube.com/embed/\(videoID)?rel=0"
            }
        }
    }
    
    static var youTubeThumbnail: (String) -> String {
        get {
            return { imageUrl in
                return "https://i.ytimg.com/vi/\(imageUrl)/hqdefault.jpg"
            }
        }
    }
    
    static let headers = [
        "accept": "application/json",
        "Authorization": Links.staticBearer
    ]
    
}

enum MovieDBErrors: Error {
    case badURL
    case badResponse
    case badData
}

enum MediaType {
    case movies
    case tvSeries
}

enum APIOperations {
    case fetchSeries
    case fetchSeriesDetails
    case fetchSeriesCast
    case fetchSeriesVideos
    case searchSeriesByTitle
    case fetchMovies
    case fetchMovieDetails
    case fetchMovieCast
    case fetchMovieVideos
    case searchMovieByTitle
    
    typealias ModelType = Codable
    
    func chooseModel() -> ModelType.Type {
        switch self {
            
        case .fetchSeries:
            return TVSeriesData.self
        case .fetchSeriesDetails:
            return TVSeriesDetailsData.self
        case .fetchSeriesCast:
            return MediaCastDecoder.self
        case .fetchSeriesVideos:
            return MediaVideosDecoder.self
        case .searchSeriesByTitle:
            return TVSeriesData.self
        case .fetchMovies:
            return MoviesData.self
        case .fetchMovieDetails:
            return MovieDetailsData.self
        case .fetchMovieCast:
            return MediaCastDecoder.self
        case .fetchMovieVideos:
            return MediaVideosDecoder.self
        case .searchMovieByTitle:
            return MoviesData.self
        }
    }
    
    func chooseOperation(for mediaType: MediaType, key: String, page: Int) -> String {
        let baseURL: String
        let type: String
        switch mediaType {
        case .tvSeries:
            baseURL = "https://api.themoviedb.org/3/"
            type = "tv"
        case .movies:
            baseURL = "https://api.themoviedb.org/3/"
            type = "movie"
        }
        
        switch self {
        case .fetchSeries:
            return "\(baseURL)\(type)/\(key)?language=en-US&page=\(page)"
        case .fetchSeriesDetails:
            return "\(baseURL)\(type)/\(key)?language=en-US"
        case .fetchSeriesCast:
            return "\(baseURL)\(type)/\(key)/credits?language=en-US"
        case .fetchSeriesVideos:
            return "\(baseURL)\(type)/\(key)/videos?language=en-US"
        case .searchSeriesByTitle:
            return "\(baseURL+"search/")\(type)?query=\(key)&include_adult=false&language=en-US&page=\(page)"
        case .fetchMovies:
            return "\(baseURL)\(type)/\(key)?language=en-US&page=\(page)"
        case .fetchMovieDetails:
            return "\(baseURL)\(type)/\(key)?language=en-US"
        case .fetchMovieCast:
            return "\(baseURL)\(type)/\(key)/credits?language=en-US"
        case .fetchMovieVideos:
            return "\(baseURL)\(type)/\(key)/videos?language=en-US"
        case .searchMovieByTitle:
            return "\(baseURL+"search/")\(type)?query=\(key)&include_adult=false&language=en-US&page=\(page)"
        }
    }
    
}

enum HTTPMethod {
    case post
    case get
    
    func chooseMethod() -> String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        }
    }
    
}
