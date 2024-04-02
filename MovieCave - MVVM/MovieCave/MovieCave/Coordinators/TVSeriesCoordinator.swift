//
//  AddMovieCoordinator.swift
//  MovieCave
//
//  Created by Admin on 28.09.23.
//

import UIKit

protocol TVSeriesCoordinatorDelegate: AnyObject {
    
    /// Loads the TVSeriesDetailsView and ViewModel to display additional
    /// information for a selected TV series.
    /// - Parameter ID: The ID of the selected TV series to load details for.
    func loadSeriesDetailsView(with seriesID: Int)
}

class TVSeriesCoordinator: Coordinator, TVSeriesCoordinatorDelegate {
    
    //MARK: - Properties
    private var navController: UINavigationController
    
    //MARK: - Initialization
    init(navController: UINavigationController) {
        self.navController = navController
    }
    
    //MARK: - Override methods
    override func start() {
        guard let tvSeriesVC = TVSeriesViewController.initFromStoryBoard() else { return }
        
        tvSeriesVC.viewModel = TVSeriesViewModel(tvSeriesViewCoordinatorDelegate: self,
                                                 movieDBService: MovieDBService(),
                                                 currentPage: Constants.firstPage,
                                                 list: .topRated)
        identifier = Constants.tvSeriesViewCoordinatorID
        navController.pushViewController(tvSeriesVC, animated: true)
    }

    //MARK: - TVSeriesViewCoordinatorDelegate
    func loadSeriesDetailsView(with seriesID: Int) {
        guard let movieDetailsVC = TvSeriesDetailsViewController.initFromStoryBoard() else { return }
        
        movieDetailsVC.viewModel = TvSeriesDetailsViewModel(mediaID: seriesID,
                                                            tvSeriesCoordinatorDelegate: self,
                                                            apiService: MovieDBService(),
                                                            with: .tvSeries)
        navController.pushViewController(movieDetailsVC, animated: true)
    }

}
