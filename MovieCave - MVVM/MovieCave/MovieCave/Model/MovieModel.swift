//
//  MovieModel.swift
//  MovieCave
//
//  Created by Admin on 3.10.23.
//

import Foundation

struct MoviesData: Codable {
    var page: Int
    var totalPages: Int
    var results: [MovieResults]
}

struct MovieResults: Codable {
    var id: Int
    var originalTitle: String
    var overview: String
    var genreIds: [Int]
    var posterPath: String?
}

struct MoviesModel {
    var page: Int
    var totalPages: Int
    var modelResults: [MovieModelResults]
}

struct MovieModelResults {
    var movieResults: MovieResults
    var isFavorite: Bool
}

struct MovieDetailsData: Codable {
    var genres: [Genres]
    var id: Int
    var firstAirDate: String
    var runtime: Int
    var voteAverage: Double
    var voteCount: Int
    var backdropPath: String?
    var posterPath: String?
    var name: String
    var overview: String
    
    struct Genres: Codable {
        var id: Int
        var name: String
    }
    
    private enum CodingKeys: String, CodingKey {
        case genres
        case id
        case firstAirDate = "releaseDate"
        case name = "originalTitle"
        case backdropPath
        case posterPath
        case voteAverage
        case voteCount
        case overview
        case runtime
    }
}

enum MoviesList {
    case favorites
    case allMovies
}

enum MovieGenreLists {
    case topRated
    case popular
    case nowPlaying
    case upComing
    
    func movieList() -> String {
        switch self {
        case .topRated:
            return "top_rated"
        case .popular:
            return "popular"
        case .nowPlaying:
            return "now_playing"
        case .upComing:
            return "upcoming"
        }
    }
}
