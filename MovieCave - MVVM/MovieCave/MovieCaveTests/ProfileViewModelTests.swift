//
//  ProfileViewModelTests.swift
//  MovieCaveTests
//
//  Created by Admin on 6.12.23.
//

import XCTest
@testable import MovieCave

final class ProfileViewModelTests: XCTestCase {
    
    var viewModel: ProfileViewModelProtocol!
    var coordinatorMock: MockCoordinator!
    var movieDBManagerMock: MovieDBManagerMock!
    
    override func setUp() {
        super.setUp()
        coordinatorMock = MockCoordinator(successType: .happy)
        coordinatorMock.parentCoordinator = coordinatorMock
        viewModel = ProfileViewModel(coordinator: coordinatorMock, userInfoMessage: "Hello user")
    }

    override func tearDown() {
       super.tearDown()
        coordinatorMock = nil
        viewModel = nil
    }
    
    func test_logOut_SadCase() {
        // Given
        coordinatorMock.successType = .sad
        
        // When
        viewModel.logOut()
        
        // Then
        XCTAssertNotEqual([], coordinatorMock.childCoordinators)
    }

    func test_logOut_HappyCase() {
        // Given
        
        // When
        viewModel.logOut()
        
        // Then
        XCTAssertEqual([], coordinatorMock.childCoordinators)
    }
    
    func test_goToFavoriteMovies_SadCase() {
        // Given
        coordinatorMock.successType = .sad
        
        // When
        viewModel.goToFavoriteMovies()
        
        // Then
        XCTAssertEqual([], coordinatorMock.childCoordinators)
    }
    
    func test_goToFavoriteMovies_HappyCase() {
        // Given
        
        // When
        viewModel.goToFavoriteMovies()
        
        // Then
        XCTAssertNotEqual([], coordinatorMock.childCoordinators)
    }
    
    func test_editPersonalInfo_SadCase() {
        // Given
        coordinatorMock.successType = .sad
        
        // When
        viewModel.editPersonalInfo()
        
        // Then
        XCTAssertEqual([], coordinatorMock.childCoordinators)
        
    }
    
    func test_editPersonalInfo_HappyCase() {
        // Given
        
        // When
        viewModel.editPersonalInfo()
        
        // Then
        XCTAssertNotEqual([], coordinatorMock.childCoordinators)
        
    }
}
