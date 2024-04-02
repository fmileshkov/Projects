//
//  MoviesViewCoordinator.swift
//  MovieCave
//
//  Created by Admin on 28.09.23.
//

import UIKit

protocol MoviesCoordinatorDelegate: AnyObject {
    
    /// Loads the MovieDetailsView and ViewModel to display additional
    /// information for a selected movie.
    /// - Parameter ID: The ID of the selected movie to load details for.
    func loadMovieDetailsView(with movieID: Int)
    
    /// Removes the coordinator from coordinator  hierarchy.
    func deallocateCoordinator()
}

class MoviesCoordinator: Coordinator, MoviesCoordinatorDelegate {
    
    //MARK: - Properties
    private var navController: UINavigationController
    private var list: MoviesList
    var navigation = UINavigationController()
    
    //MARK: - Initialization
    init(navController: UINavigationController, with list: MoviesList) {
        self.navController = navController
        self.list = list
    }
    
    //MARK: - Override methods
    override func start() {
        guard let moviesVC = MoviesViewController.initFromStoryBoard() else { return }

        moviesVC.viewModel = MoviesViewModel(movieCoordinatorDelegate: self,
                                             movieDBService: MovieDBService(),
                                             dataSource: CollectionViewDataSource(items: []),
                                             with: list,
                                             with: .topRated,
                                             currentPage: Constants.firstPage)
        identifier = Constants.moviesViewCoordinatorID
        navController.pushViewController(moviesVC, animated: true)
    }
    
    //MARK: - MoviesViewCoordinatorDelegate
    func loadMovieDetailsView(with movieID: Int) {
        guard let movieDetailsVC = MoviesDetailsViewController.initFromStoryBoard() else { return }

        movieDetailsVC.viewModel = MoviesDetailsViewModel(mediaID: movieID,
                                                          movieDetailsViewCoordinatorDelegate: self,
                                                          apiService: MovieDBService(),
                                                          with: .movies)
        navController.pushViewController(movieDetailsVC, animated: true)
    }
    
    func deallocateCoordinator() {
        removeChildCoordinator(self)
    }
}
