//
//  TVSeriesModel.swift
//  MovieCave
//
//  Created by Admin on 13.10.23.
//

import Foundation

struct TVSeriesData: Codable {
    var page: Int
    var totalPages: Int
    var results: [TVSeriesResults]
}

struct TVSeriesResults: Codable {
    var id: Int
    var name: String
    var overview: String
    var genreIds: [Int]
    var posterPath: String?
}

struct TVSeriesDetailsData: Codable {
    var genres: [Genres]
    var id: Int
    var firstAirDate: String
    var name: String
    var backdropPath: String?
    var posterPath: String?
    var voteAverage: Double
    var voteCount: Double
    var overview: String
    var runtime: Int?

    struct Genres: Codable {
        var id: Int
        var name: String
    }
    
    private enum CodingKeys: String, CodingKey {
        case genres
        case id
        case firstAirDate
        case name
        case backdropPath
        case posterPath
        case voteAverage
        case voteCount
        case overview
        case runtime
    }
}

enum TVSeriesLists {
    case topRated
    case popular
    case airingToday
    case onTheAir
    
    func tvSeriesList() -> String {
        switch self {
        case .topRated:
            return "top_rated"
        case .popular:
            return "popular"
        case .airingToday:
            return "airing_today"
        case .onTheAir:
            return "on_the_air"
        }
    }
}
