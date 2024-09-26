//
//  AppCoordinator.swift
//  MovieCave
//
//  Created by Admin on 27.09.23.
//

import UIKit

//MARK: - AppCoordinatorProtocol
protocol AppCoordinatorProtocol {
    
    /// Shows the login flow.
    func showLoginFlow()
    
    /// Loads the login view and removes the child coordinators.
    func loadLogInPage()
    
    /// Navigates to the tab bar coordinator and removes the logInCoordinator from the childCoordinators array.
    func navigateToTabBarCoordinator()
}

class AppCoordinator: Coordinator, AppCoordinatorProtocol {
    
    //MARK: - Properties
    private var rootNavController: UINavigationController
        
    //MARK: - Initializer
    init(rootNavController: UINavigationController) {
        self.rootNavController = rootNavController
    }

    //MARK: - Methods
    override func start() {
        showLoginFlow()
    }

    //MARK: - RootCoordinatorProtocol
    func showLoginFlow() {
        let logInCoordinator = LoginCoordinator(navController: rootNavController)
        
        addChildCoordinator(logInCoordinator)
        logInCoordinator.start()
    }
    
    func navigateToTabBarCoordinator() {
        let tabBarCoordinator = TabBarCoordinator(rootNavController: rootNavController)
        addChildCoordinator(tabBarCoordinator)
        tabBarCoordinator.start()
        removeAllChildCoordinatorsWith(type: LoginCoordinator.self)
    }
    
    func loadLogInPage() {
        rootNavController.viewControllers.removeAll()
        removeAllChildCoordinators()
        showLoginFlow()
    }
    
}
