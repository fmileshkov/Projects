//
//  DetailsScreenViewModelTests.swift
//  MovieCaveTests
//
//  Created by Admin on 1.12.23.
//

import XCTest
@testable import MovieCave

final class MovieDetailsScreenViewModelTests: XCTestCase {
    
    var mockMovieDBService: MovieDBManagerMock!
    var movieCoordinator: MoviesCoordinator!
    var viewModel: MoviesDetailsViewModel!
    let navController = UINavigationController()
    
    override func setUp() {
        super.setUp()
        mockMovieDBService = MovieDBManagerMock(succesCase: .happy, moviesList: .allMovies)
    }
    
    override func tearDown() {
        super.tearDown()
        mockMovieDBService = nil
        movieCoordinator = nil
        viewModel = nil
    }
    
    
    func test_DetailsView_withMovies_HappyCase() {
        // Given
        let id = 10
        movieCoordinator = MoviesCoordinator(navController: navController, with: .allMovies)
        viewModel = MoviesDetailsViewModel(mediaID: id, movieDetailsViewCoordinatorDelegate: movieCoordinator, apiService: mockMovieDBService, with: .movies)
        // When
        
        
        // Then
        XCTAssertEqual(viewModel.mediaDetails.value, mockMovieDBService.mediaDetails)
        XCTAssertEqual(viewModel.mediaVideos.value?.last, mockMovieDBService.mediaVideos)
        XCTAssertEqual(viewModel.mediaCast.value?.last, mockMovieDBService.mediaCast)
        XCTAssertNil(mockMovieDBService.apiCallError)
        XCTAssertNotNil(mockMovieDBService.apiCallMoviesResult?.modelResults)
        XCTAssertNotNil(viewModel.mediaCast.value)
        XCTAssertNotNil(viewModel.mediaVideos.value)
        XCTAssertNotNil(viewModel.mediaDetails.value)
    }
    
    func test_DetailsView_withMovies_SadCase() {
        // Given
        let id = 10
        movieCoordinator = MoviesCoordinator(navController: navController, with: .allMovies)
        mockMovieDBService.succesCase = .sad
        viewModel = MoviesDetailsViewModel(mediaID: id, movieDetailsViewCoordinatorDelegate: movieCoordinator, apiService: mockMovieDBService, with: .movies)
        
        // When
        
        
        // Then
        XCTAssertEqual(viewModel.popUpMessage.value, mockMovieDBService.apiCallError)
        XCTAssertNotNil(viewModel.popUpMessage)
        XCTAssertNotNil(mockMovieDBService.apiCallError)
        XCTAssertNil(mockMovieDBService.apiCallMoviesResult?.modelResults)
        XCTAssertNil(viewModel.mediaCast.value)
        XCTAssertNil(viewModel.mediaVideos.value)
        XCTAssertNil(viewModel.mediaDetails.value)
    }
    
}
