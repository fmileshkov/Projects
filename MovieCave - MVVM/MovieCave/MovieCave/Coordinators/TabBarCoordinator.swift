//
//  MainCoordinator.swift
//  MovieCave
//
//  Created by Admin on 20.09.23.
//

import UIKit

protocol TabBarCoordinatorDelegate: NSObject {
    
    /// Handles the click event of a tab bar item with the specified item name.
    /// - Parameter itemName: The name of the tab bar item that was clicked.
    func tabBarItemClicked(itemName: String)
}

class TabBarCoordinator: Coordinator, TabBarCoordinatorDelegate {

    //MARK: - Properties
    private var rootNavController: UINavigationController
    private let pages: [TabBarPage] = [.movies, .tvSeries, .profile]
        .sorted(by: {
            $0.pageOrderNumber() < $1.pageOrderNumber()
        })
    
    //MARK: - Initializer
    init(rootNavController: UINavigationController) {
        self.rootNavController = rootNavController
    }
    
    //MARK: - Methods
    override func start() {
        let controllers: [UINavigationController] = pages.map({ getTabController($0) })

        prepareTabBarController(withTabControllers: controllers)
        identifier = Constants.tabBarCoordinatorID
    }
    
    private func prepareTabBarController(withTabControllers tabControllers: [UIViewController]) {
        guard let tabBarController = MainTabBarController.initFromStoryBoard() else { return }

        tabBarController.viewModel = MainTabBarViewModel(tabBarCoordinatorDelegate: self)
        tabBarController.setViewControllers(tabControllers, animated: true)
        tabBarController.selectedIndex = TabBarPage.movies.pageOrderNumber()

        rootNavController.viewControllers = [tabBarController]
    }
    
    private func getTabController(_ page: TabBarPage) -> UINavigationController {
        let navController = UINavigationController()
            navController.tabBarItem = UITabBarItem.init(title: page.pageTitleValue(),
                                                         image: page.pageIcon(),
                                                         tag: page.pageOrderNumber())

            switch page {
            case .movies:
                let moviesCoordinator = MoviesCoordinator(navController: navController, with: .allMovies)
                addChildCoordinator(moviesCoordinator)
                moviesCoordinator.start()
            case .tvSeries:
                let addMovieCoordinator = TVSeriesCoordinator(navController: navController)
                addChildCoordinator(addMovieCoordinator)
                addMovieCoordinator.start()
            case .profile:
                let profileCoordinator = ProfileViewCoordinator(navController: navController)
                addChildCoordinator(profileCoordinator)
                profileCoordinator.start()
            }

            return navController
        }

    //MARK: - TabBarCoordinatorDelegate
    func tabBarItemClicked(itemName: String) {
        guard let tabBar: TabBarPage = pages.first(where: {$0.pageTitleValue() == itemName}) else { return }

    }

}
