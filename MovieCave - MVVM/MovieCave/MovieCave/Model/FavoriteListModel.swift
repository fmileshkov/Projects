//
//  FavoriteListModel.swift
//  MovieCave
//
//  Created by Admin on 3.10.23.
//

import Foundation

struct FavoriteList: Codable {
    var page: Int
    var totalPages: Int
    var items: [FavoriteResult]
}

struct FavoriteResult: Codable {
    var id: Int
    var originalTitle: String
}

enum Favorites {
    case addToFavorites
    case removeFromFavorites
    
    func operationType() -> String {
        switch self {
        case .addToFavorites:
            return "add_item"
        case .removeFromFavorites:
            return "remove_item"
        }
    }
}
