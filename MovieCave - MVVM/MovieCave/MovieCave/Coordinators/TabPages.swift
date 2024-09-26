//
//  TabPages.swift
//  MovieCave
//
//  Created by Admin on 26.09.23.
//

import UIKit

enum TabBarPage {
    case tvSeries
    case movies
    case profile

    //MARK: - Initializer
    init?(index: Int) {
        switch index {
        case 0:
            self = .tvSeries
        case 1:
            self = .movies
        case 2:
            self = .profile
        default:
            return nil
        }
    }

    //MARK: - Methods
    func pageTitleValue() -> String {
        switch self {
        case .tvSeries:
            return "TV Series"
        case .movies:
            return "Movies"
        case .profile:
            return "Profile"
        }
    }

    func pageOrderNumber() -> Int {
        switch self {
        case .tvSeries:
            return 0
        case .movies:
            return 1
        case .profile:
            return 2
        }
    }

    func pageIcon() -> UIImage {
        switch self {
        case .tvSeries:
            return UIImage(systemName: "play.tv")!
        case .movies:
            return UIImage(systemName: "film")!
        case .profile:
            return UIImage(systemName: "person.text.rectangle")!
        }
    }

}

