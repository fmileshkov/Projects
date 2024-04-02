//
//  MovieDetailsViewCoordinator.swift
//  MovieCave
//
//  Created by Admin on 3.10.23.
//

import UIKit

class MovieDetailsViewCoordinator: Coordinator {
    
    private var navController: UINavigationController
    private var movieID: Int
    
    init(navController: UINavigationController, movieID: Int) {
        self.navController = navController
        self.movieID = movieID
    }
    
    override func start() {
//        guard let movieDetailsVC = MoviesDetailsViewController.initFromStoryBoard() else { return }
//
//        movieDetailsVC.viewModel = MoviesDetailsViewModel(mediaID: movieID,
//                                                          movieDetailsViewCoordinatorDelegate: self,
//                                                          apiService: MovieDBService(),
//                                                          with: .movies)
//        navController.pushViewController(movieDetailsVC, animated: true)
    }
    
}
