//
//  TVSeriesDetailsCoordinator.swift
//  MovieCave
//
//  Created by Admin on 16.10.23.
//

import UIKit

class TVSeriesDetailsCoordinator: Coordinator {
    
    //MARK: - Properties
    private var navController: UINavigationController
    private var seriesID: Int
    
    //MARK: - Initialization
    init(navController: UINavigationController, seriesID: Int) {
        self.navController = navController
        self.seriesID = seriesID
    }
    
    //MARK: - Override methods
    override func start() {
        guard let movieDetailsVC = TvSeriesDetailsViewController.initFromStoryBoard() else { return }
        
        movieDetailsVC.viewModel = TvSeriesDetailsViewModel(mediaID: seriesID,
                                                            tvSeriesDetailsCoordinatorDelegate: self,
                                                            apiService: MovieDBService(),
                                                            with: .tvSeries)
        identifier = Constants.tvSeriesDetailsCoordinatorID
        navController.pushViewController(movieDetailsVC, animated: true)
    }
    
}
