//
//  ProfileViewModel.swift
//  MovieCave
//
//  Created by Admin on 27.09.23.
//

import Foundation
import Combine

//MARK: - ProfileViewModelProtocol
protocol ProfileViewModelProtocol {
    /// Edits the personal information of the user.
    func editPersonalInfo()
    
    /// Navigates to the favorite movies screen.
    func goToFavoriteMovies()
    
    /// Logs out the user.
    func logOut()
    
    /// A subject that holds the user information message.
    var userInfoMessage: CurrentValueSubject<String?, Never> { get }
}

class ProfileViewModel: ProfileViewModelProtocol {

    //MARK: - Properties
    private weak var coordinator: ProfileViewCoordinatorDelegate?
    var userInfoMessage: CurrentValueSubject<String?, Never> = CurrentValueSubject(nil)
    
    //MARK: - Initializer
    init(coordinator: ProfileViewCoordinatorDelegate, userInfoMessage: String) {
        self.coordinator = coordinator
        self.userInfoMessage.send(userInfoMessage)
    }

    //MARK: - Methods
    func editPersonalInfo() {
        coordinator?.loadPersonalInfoView()
    }
    
    func goToFavoriteMovies() {
        coordinator?.loadFavoriteMoviesView()
    }

    func logOut() {
        coordinator?.logOut()
    }
    
}
