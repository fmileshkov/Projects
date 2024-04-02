//
//  PersonalInfoViewModel.swift
//  MovieCave
//
//  Created by Admin on 26.10.23.
//

import Foundation
import Combine

//MARK: - PersonalInfoViewModelProtocol
protocol PersonalInfoViewModelProtocol {
    /// Tells the view model to save any pending changes to the user's personal information.
    func saveChanges()
    
    /// Removes the reference to the coordinator so the view model can be deinitialized.
    func removeCoordinator()
    
    /// A publisher that emits a message whenever the view model's saved changes state changes. Used to notify the UI when it needs to update.
    var changeMessage: CurrentValueSubject<String?, Never> { get }
}

class PersonalInfoViewModel: PersonalInfoViewModelProtocol {
    
    //MARK: - Properties
    private weak var personalInfoViewCoordinatorDelegate: PersonalInfoViewCoordinatorDelegate?
    private let apiService: MovieDBServiceProtocol
    var changeMessage: CurrentValueSubject<String?, Never> = CurrentValueSubject(nil)
    
    //MARK: - Initializer
    init(personalInfoViewCoordinatorDelegate: PersonalInfoViewCoordinatorDelegate?, apiService: MovieDBServiceProtocol) {
        self.personalInfoViewCoordinatorDelegate = personalInfoViewCoordinatorDelegate
        self.apiService = apiService
    }
    
    //MARK: - Methods
    func saveChanges() {
        changeMessage.send("Your personal info was changed successfully.")
    }
    
    func removeCoordinator() {
        personalInfoViewCoordinatorDelegate?.deallocateCoordinator()
    }
    
}
