//
//  MockCoordinator.swift
//  MovieCaveTests
//
//  Created by Admin on 4.12.23.
//

import UIKit
@testable import MovieCave

enum CoordinatorSuccessType {
    case happy
    case sad
}
class MockCoordinator: Coordinator, ProfileViewCoordinatorDelegate, TabBarCoordinatorDelegate, LoginCoordinatorDelegate, PersonalInfoViewCoordinatorDelegate, TVSeriesCoordinatorDelegate, MoviesCoordinatorDelegate {

    let navController = UINavigationController()
    var successType: CoordinatorSuccessType
    var tabBarItemName: String?
    var mediaID: Int?
    
    init(successType: CoordinatorSuccessType) {
        self.successType = successType
    }
    
    //MARK: - MoviesViewCoordinatorDelegate
    func loadMovieDetailsView(with movieID: Int) {
        switch successType {
        case .happy:
            let moviesDetailCoord = MoviesCoordinator(navController: navController, with: .allMovies)
            parentCoordinator?.addChildCoordinator(moviesDetailCoord)
            identifier = "MovieDetails coordinator"
            mediaID = movieID
            moviesDetailCoord.start()
        case .sad:
            childCoordinators = []
            identifier = nil
            mediaID = nil
        }
    }
    
    //MARK: - TVSeriesViewCoordinatorDelegate
    func loadSeriesDetailsView(with seriesID: Int) {
        switch successType {
        case .happy:
            let tvSeriesDetailsCoord = TVSeriesCoordinator(navController: navController)
            parentCoordinator?.addChildCoordinator(tvSeriesDetailsCoord)
            identifier = "TVSeriesDetails coordinator"
            mediaID = seriesID
            tvSeriesDetailsCoord.start()
        case .sad:
            childCoordinators = []
            identifier = nil
            mediaID = nil
        }
    }
    
    //MARK: - PersonalInfoViewCoordinatorProtocol
    func deallocateCoordinator() {
        switch successType {
        case .happy:
            childCoordinators = []
            identifier = nil
        case .sad:
            let personalInfoCoord = PersonalInfoViewCoordinator(navController: navController)
            parentCoordinator?.addChildCoordinator(personalInfoCoord)
            identifier = "Personal coordinator"
        }
    }
    

    //MARK: - LoginViewCoordinator
    func goToTabBarController() {
        switch successType {
        case .happy:
            let tabBarCoortinator = TabBarCoordinator(rootNavController: navController)
            parentCoordinator?.addChildCoordinator(tabBarCoortinator)
        case .sad:
            break
        }
    }
    
    //MARK: - MainTabBarCoordinator Protocol
    func tabBarItemClicked(itemName: String) {
        switch successType {
        case .happy:
            tabBarItemName = itemName
        case .sad:
            tabBarItemName = nil
        }
    }
    
    
    //MARK: - ProfileCoordinatorProtocol
    func loadFavoriteMoviesView() {
        switch successType {
        case .happy:
            let favoriteMoviesCoordinator = MoviesCoordinator(navController: navController, with: .favorites)
            parentCoordinator?.addChildCoordinator(favoriteMoviesCoordinator)
        case .sad:
            break
        }
    }
    
    func loadPersonalInfoView() {
        switch successType {
        case .happy:
            let personalInfoCoordinator = PersonalInfoViewCoordinator(navController: navController)
            parentCoordinator?.addChildCoordinator(personalInfoCoordinator)
        case .sad:
            break
        }
    }
    
    func logOut() {
        switch successType {
        case .happy:
            removeAllChildCoordinators()
        case .sad:
            let personalInfoCoordinator = PersonalInfoViewCoordinator(navController: navController)
            parentCoordinator?.addChildCoordinator(personalInfoCoordinator)
        }
    }
    
}
