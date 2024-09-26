//
//  ProfileViewController.swift
//  MovieCave
//
//  Created by Admin on 21.09.23.
//

import UIKit
import Combine

class ProfileViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet private weak var infoLabel: UILabel!
    
    //MARK: - Properties
    var viewModel: ProfileViewModelProtocol?
    private var cancellables: [AnyCancellable] = []
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constants.profileNavBarTitle
        setUpBindes()
    }
    
    //MARK: - Methods
    func setUpBindes() {
        viewModel?.userInfoMessage.sink { [weak self] messsage in
            self?.infoLabel.text = messsage
        }.store(in: &cancellables)
    }
    
    //MARK: - IBActions
    @IBAction private func logOutButton(_ sender: UIButton) {
        viewModel?.logOut()
    }
    
    @IBAction private func favoriteMoviesButton(_ sender: UIButton) {
        viewModel?.goToFavoriteMovies()
    }
    
    @IBAction private func editPersonalButton(_ sender: UIButton) {
        viewModel?.editPersonalInfo()
    }
    
}
