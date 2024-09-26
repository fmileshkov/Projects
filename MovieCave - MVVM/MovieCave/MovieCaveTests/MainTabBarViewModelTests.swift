//
//  MainTabBarViewModelTests.swift
//  MovieCaveTests
//
//  Created by Admin on 9.12.23.
//

import XCTest
@testable import MovieCave

final class MainTabBarViewModelTests: XCTestCase {

    var viewModel: MainTabBarViewModelProtocol!
    var coordinatorMock: MockCoordinator!
    var movieDBManagerMock: MovieDBManagerMock!
    
    override func setUp() {
        super.setUp()
        coordinatorMock = MockCoordinator(successType: .happy)
        coordinatorMock.parentCoordinator = coordinatorMock
        viewModel = MainTabBarViewModel(tabBarCoordinatorDelegate: coordinatorMock)
    }

    override func tearDown() {
       super.tearDown()
        coordinatorMock = nil
        viewModel = nil
    }
    
    func test_tabBarItemPressed_HappyCase() {
        // Given
        let name = "TAB BAR NAME"
        
        // When
        viewModel.tabBarItemPressed(tabBar: name)
        
        // Then
        XCTAssertEqual(name, coordinatorMock.tabBarItemName)
        XCTAssertNotNil(coordinatorMock.tabBarItemName)
    }

    func test_tabBarItemPressed_SadCase() {
        // Given
        coordinatorMock.successType = .sad
        let name = ""
        
        // When
        viewModel.tabBarItemPressed(tabBar: name)
        
        // Then
        XCTAssertNil(coordinatorMock.tabBarItemName)
    }
    
}
