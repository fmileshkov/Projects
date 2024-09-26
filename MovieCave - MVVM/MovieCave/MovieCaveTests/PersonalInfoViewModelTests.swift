//
//  PersonalInfoViewModelTests.swift
//  MovieCaveTests
//
//  Created by Admin on 12.12.23.
//

import XCTest
@testable import MovieCave

final class PersonalInfoViewModelTests: XCTestCase {
    
    var viewModel: PersonalInfoViewModelProtocol!
    var coordinatorMock: MockCoordinator!
    var movieDBManagerMock: MovieDBManagerMock!
    
    override func setUp() {
        super.setUp()
        coordinatorMock = MockCoordinator(successType: .happy)
        coordinatorMock.parentCoordinator = coordinatorMock
        movieDBManagerMock = MovieDBManagerMock(succesCase: .happy, moviesList: .allMovies)
        viewModel = PersonalInfoViewModel(personalInfoViewCoordinatorDelegate: coordinatorMock, apiService: movieDBManagerMock)
    }

    override func tearDown() {
       super.tearDown()
        coordinatorMock = nil
        movieDBManagerMock = nil
        viewModel = nil
    }
    
    func test_saveChanges_HappyCase() {
        // Given
        let expected = "Your personal info was changed successfully."
        
        // When
        viewModel.saveChanges()
        
        // Then
        XCTAssertNotNil(viewModel.changeMessage.value)
        XCTAssertEqual(viewModel.changeMessage.value, expected)
        
    }

    func test_saveChanges_SadCase() {
        // Given
        coordinatorMock.successType = .sad
        
        // When
        viewModel.removeCoordinator()
        
        // Then
        XCTAssertNotNil(coordinatorMock.identifier)
        XCTAssertEqual("Personal coordinator", coordinatorMock.identifier)
        XCTAssertNotEqual([], coordinatorMock.childCoordinators)
    }
    
    func test_removeCoordinator_HappyCase() {
        // Given
        
        // When
        viewModel.removeCoordinator()
        
        // Then
        XCTAssertEqual([], coordinatorMock.childCoordinators)
        XCTAssertNil(coordinatorMock.identifier)
    }
}
