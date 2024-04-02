//
//  PersonalInfoViewCoordinator.swift
//  MovieCave
//
//  Created by Admin on 26.10.23.
//

import UIKit

//MARK: - PersonalInfoViewCoordinatorProtocol
protocol PersonalInfoViewCoordinatorDelegate: AnyObject {
    
    /// Delocates the current coordinator.
    func deallocateCoordinator()
}

class PersonalInfoViewCoordinator: Coordinator, PersonalInfoViewCoordinatorDelegate {
    
    //MARK: - Properties
    private var navController: UINavigationController
    
    //MARK: - Initialization
    init(navController: UINavigationController) {
        self.navController = navController
    }
    
    //MARK: - Override methods
    override func start() {
        guard let personalInfoVC = PersonalInfoViewController.initFromStoryBoard() else { return }
        
        personalInfoVC.viewModel = PersonalInfoViewModel(personalInfoViewCoordinatorDelegate: self, apiService: MovieDBService())
        identifier = Constants.personalInfoCoordinatorID
        navController.pushViewController(personalInfoVC, animated: true)
    }
    
    //MARK: - PersonalInfoViewCoordinatorProtocol
    func deallocateCoordinator() {
        removeChildCoordinator(self)
    }
    
}
