//
//  LoginViewModelTests.swift
//  MovieCaveTests
//
//  Created by Admin on 9.12.23.
//

import XCTest
@testable import MovieCave

final class LoginViewModelTests: XCTestCase {

    var viewModel: LoginViewModelProtocol!
    var coordinatorMock: MockCoordinator!
    var movieDBManagerMock: MovieDBManagerMock!
    
    override func setUp() {
        super.setUp()
        coordinatorMock = MockCoordinator(successType: .happy)
        coordinatorMock.parentCoordinator = coordinatorMock
        movieDBManagerMock = MovieDBManagerMock(succesCase: .happy, moviesList: .allMovies)
        viewModel = LoginViewModel(logInCoordinatorDelegate: coordinatorMock, apiService: movieDBManagerMock)
    }

    override func tearDown() {
       super.tearDown()
        coordinatorMock = nil
        movieDBManagerMock = nil
        viewModel = nil
    }
    
    func test_getRequestToken_HappyCase() {
        // Given
        
        // When
        viewModel.getRequestToken()
        
        // Then
        XCTAssertEqual(true, movieDBManagerMock.fetchRequestTokenCalled)
    }
    
    func test_getRequestToken_SadCase() {
        // Given
        movieDBManagerMock.succesCase = .sad
        
        // When
        viewModel.getRequestToken()
        
        // Then
        XCTAssertEqual(false, movieDBManagerMock.fetchRequestTokenCalled)
    }
    
    func test_logIn_HappyCase() {
        // Given
        
        // When
        viewModel.logIn()
        
        // Then
        XCTAssertNotEqual([], coordinatorMock.childCoordinators)
    }
    
    func test_logIn_SadCase() {
        // Given
        coordinatorMock.successType = .sad
        
        // When
        viewModel.logIn()
        
        // Then
        XCTAssertEqual([], coordinatorMock.childCoordinators)
    }
}
