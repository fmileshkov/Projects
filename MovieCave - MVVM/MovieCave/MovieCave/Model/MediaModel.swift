//
//  MediaModel.swift
//  MovieCave
//
//  Created by Admin on 19.10.23.
//

import Foundation

struct MediaVideosDecoder: Codable {
    var results: [VideoResults]
    
    struct VideoResults: Codable {
        var name: String
        var key: String
        var site: String
        var type: String
        var id: String
    }
}

struct MediaCastDecoder: Codable {
    var cast: [CastDetails]
    
    struct CastDetails: Codable {
        var name: String
        var profilePath: String?
    }
}

struct MediaDetails: Equatable {
    var title: String
    var overview: String
    var id: Int
    var poster: String
    var bigPoster: String
    var avrgVote: String
    var releaseDate: String
    var gernes: [String]
}

struct MediaCast: Equatable {
    var name: String
    var poster: String?

}

struct MediaVideos: Equatable {
    var key: String
    var name: String
}
