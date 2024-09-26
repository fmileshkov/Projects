//
//  MainTabControllerViewController.swift
//  MovieCave
//
//  Created by Admin on 21.09.23.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {

    //MARK: - Properties
    var viewModel: MainTabBarViewModelProtocol?
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        tabBar.tintColor = .systemIndigo
        tabBar.backgroundColor = .systemGray3
        tabBar.unselectedItemTintColor = .darkGray
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let title = item.title else { return }
        
        // This function is called when a tab item is selected by the user.
        // It provides the title of the selected item, which can be used to perform specific actions or trigger navigation to different views.
        // Add your implementation here to handle the selection of the tab item and update the corresponding view or perform any necessary tasks.
    }
}
