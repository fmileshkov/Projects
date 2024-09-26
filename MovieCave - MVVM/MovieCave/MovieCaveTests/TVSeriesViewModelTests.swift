//
//  TVSeriesViewModelTests.swift
//  MovieCaveTests
//
//  Created by Admin on 16.11.23.
//

import XCTest
//import Combine
@testable import MovieCave

final class TVSeriesViewModelTests: XCTestCase {

    var mockMovieDBService: MovieDBManagerMock!
    var viewModel: TVSeriesViewModelProtocol!
    var coordinator: MockCoordinator!
    var currentPage = 1
    
    override func setUp() {
        super.setUp()
        mockMovieDBService = MovieDBManagerMock(succesCase: .sad, moviesList: .allMovies)
        coordinator = MockCoordinator(successType: .happy)
        viewModel = TVSeriesViewModel(tvSeriesViewCoordinatorDelegate: coordinator, movieDBService: mockMovieDBService, currentPage: currentPage, list: .popular)
    }

    override func tearDown() {
        super.tearDown()
        mockMovieDBService = nil
        coordinator = nil
        viewModel = nil
    }
    
    func test_sendSeriesDetails_HappyCase() {
        // Given
        let id = 10
        mockMovieDBService.succesCase = .happy
        viewModel = TVSeriesViewModel(tvSeriesViewCoordinatorDelegate: coordinator, movieDBService: mockMovieDBService, currentPage: currentPage, list: .popular)
        
        // When
        viewModel.sendSeriesDetails(with: id)
        
        // Then
        XCTAssertEqual(10, mockMovieDBService.apiCallTVSeriesResult?.results[0].id)
        XCTAssertNotNil(mockMovieDBService.apiCallTVSeriesResult?.results)
        XCTAssertEqual(10, coordinator.mediaID)
        XCTAssertNotNil(coordinator.mediaID)
    }
    
    func test_sendSeriesDetails_SadCase() {
        // Given
        let id = 12
        coordinator.successType = .sad

        // When
        viewModel.sendSeriesDetails(with: id)

        // Then
        XCTAssertNil(mockMovieDBService.apiCallTVSeriesResult?.results)
        XCTAssertNotNil(mockMovieDBService.apiCallError)
        XCTAssertNotEqual(10, coordinator.mediaID)
        XCTAssertNil(coordinator.mediaID)
    }

    func test_performSearch_HappyCase() {
        // Given
        mockMovieDBService.succesCase = .happy
        let searchText = "Happy case"

        // When
        viewModel.performSearch(with: searchText)

        // Then
        XCTAssertEqual(viewModel.dataSource.items.last?.name, mockMovieDBService.apiCallTVSeriesResult?.results.last?.name)
        XCTAssertNotNil(mockMovieDBService.apiCallTVSeriesResult?.results)
        XCTAssertEqual(searchText, mockMovieDBService.apiCallTVSeriesResult?.results[0].name)
        XCTAssertEqual(searchText, mockMovieDBService.operateWithAPIKey)
        XCTAssertNotNil(mockMovieDBService.operateWithAPIKey)
    }

    func test_performSearch_SadCase() {
        // Given
        let searchText = ""

        // When
        viewModel.performSearch(with: searchText)

        // Then
        XCTAssertEqual(viewModel.popUpMessage.value, mockMovieDBService.apiCallError)
        XCTAssertNotNil(mockMovieDBService.apiCallError)
        XCTAssertEqual(searchText, mockMovieDBService.operateWithAPIKey)
        XCTAssertNotNil(mockMovieDBService.operateWithAPIKey)
    }

    func test_filterSeries_HappyCase() {
        // Given
        mockMovieDBService = MovieDBManagerMock(succesCase: .happy, moviesList: .allMovies)
        viewModel = TVSeriesViewModel(tvSeriesViewCoordinatorDelegate: coordinator, movieDBService: mockMovieDBService, currentPage: currentPage, list: .popular)
        let filter = [Constants.popularTVSeriesFilterButton,
                      Constants.airingTodayTVSeriesFilterButton,
                      Constants.onTheAirTVSeriesFilterButton,
                      Constants.topRatedTVSeriesFilterButton]

        // When
        filter.forEach {viewModel.filterSeries($0)}

        // Then
        XCTAssertEqual(filter.last, mockMovieDBService.operateWithAPIKey)
        XCTAssertNotNil(mockMovieDBService.operateWithAPIKey)
        XCTAssertNil(mockMovieDBService.apiCallError)
        XCTAssertNil(viewModel.popUpMessage.value)
    }

    func test_filterSeries_SadCase() {
        // Given
        let filter = "Sad case"

        // When
        viewModel.filterSeries(filter)

        // Then
        XCTAssertNotEqual(filter, mockMovieDBService.operateWithAPIKey)
        XCTAssertNotNil(mockMovieDBService.operateWithAPIKey)
        XCTAssertEqual(viewModel.popUpMessage.value, mockMovieDBService.apiCallError)
        XCTAssertNotNil(mockMovieDBService.apiCallError)
        XCTAssertNotNil(viewModel.popUpMessage.value)
    }

}
