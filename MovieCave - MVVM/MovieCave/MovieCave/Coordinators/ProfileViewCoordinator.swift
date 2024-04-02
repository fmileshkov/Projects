//
//  ProfileViewCoordinator.swift
//  MovieCave
//
//  Created by Admin on 28.09.23.
//

import UIKit

protocol ProfileViewCoordinatorDelegate: NSObject {
    
    /// Loads the Favorites Movies view to display the user's favorite movies list.
    func loadFavoriteMoviesView()
    
    /// Loads the Personal Info view to display and edit the user's account details.
    func loadPersonalInfoView()
    
    /// Logs out the user by dismissing the Profile flow.
    func logOut()
}

class ProfileViewCoordinator: Coordinator, ProfileViewCoordinatorDelegate {

    //MARK: - Properties
    private var navController: UINavigationController
    
    //MARK: - Initialization
    init(navController: UINavigationController) {
        self.navController = navController
    }
    
    //MARK: - Override methods
    override func start() {
        guard let profileVC = ProfileViewController.initFromStoryBoard() else { return }

        profileVC.viewModel = ProfileViewModel(coordinator: self, userInfoMessage: Constants.userWellcomeMessage)
        identifier = Constants.profileViewCoordinatorID
        navController.pushViewController(profileVC, animated: true)
    }
    
    //MARK: - ProfileViewCoordinatorDelegate
    func loadFavoriteMoviesView() {
        let favoriteMoviesCoordinator = MoviesCoordinator(navController: navController, with: .favorites)
        addChildCoordinator(favoriteMoviesCoordinator)
        favoriteMoviesCoordinator.start()
    }
    
    func loadPersonalInfoView() {
        let personalInfoCoordinator = PersonalInfoViewCoordinator(navController: navController)
        addChildCoordinator(personalInfoCoordinator)
        personalInfoCoordinator.start()
    }
    
    func logOut() {
        guard let parent = firstParent(of: AppCoordinator.self) else { return }

        parent.loadLogInPage()
    }
    
}
