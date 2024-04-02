//
//  MoviesViewModel.swift
//  MovieCave
//
//  Created by Admin on 27.09.23.
//

import Foundation
import Combine

//MARK: - MoviesViewModelProtocol
protocol MoviesViewModelProtocol: FavoriteButtonDelegate {
    /// Performs favorite movie list operations for the specified movie ID and operation.
    /// - Parameters:
    ///   - movieID: The ID of the movie for the favorite list operation.
    ///   - operation: The favorite list operation to perform.
    func favoriteMovieListOperations(with movieID: Int, for operation: Favorites)
    
    /// Filters the movie list based on the specified genre.
    /// - Parameter genre: The genre to filter the movie list by.
    func filterMovies(_ genre: String)
    
    /// Sends the details of a movie with the specified movie ID.
    /// - Parameter movieID: The ID of the movie to retrieve details for.
    func sendMovieDetails(with movieID: Int)
    
    /// Performs a search with the specified search text.
    /// - Parameter searchText: The text to search for.
    func performSearch(with searchText: String)
    
    /// A current value publisher representing the succession state of data fetching.
    var fetchingDataSuccession: CurrentValueSubject<Bool, Never> { get }
    
    /// The coordinator responsible for handling movie view navigation.
    var movieCoordinatorDelegate: MoviesCoordinatorDelegate? { get }
    
    /// A subject that holds the pop-up message.
    var popUpMessage: CurrentValueSubject<String?, Never> { get }
    
    /// A subject that holds the reset position flag.
    var resetPosition: CurrentValueSubject<Bool, Never> { get }
    
    /// A subject that holds the index of the favorite button.
    var favoriteButtonIndex: CurrentValueSubject<Int?, Never> { get }
    
    /// The data source for the collection view.
    var dataSource: CollectionViewDataSource<MovieModelResults> { get }
}

class MoviesViewModel: MoviesViewModelProtocol {
    
    //MARK: - Properties
    weak var movieCoordinatorDelegate: MoviesCoordinatorDelegate?
    private let movieDBService: MovieDBServiceProtocol
    private var list: MoviesList
    private var currentPage: Int
    private var genreList: MovieGenreLists
    private var currentSearchText: String = ""
    private var moviesArray: [MovieModelResults] = []
    private var currentOperationType: APIOperations = .fetchMovies
    
    var dataSource: CollectionViewDataSource<MovieModelResults> = CollectionViewDataSource(items: [])
    var fetchingDataSuccession: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)
    var popUpMessage: CurrentValueSubject<String?, Never> = CurrentValueSubject(nil)
    var resetPosition: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)
    var favoriteButtonIndex: CurrentValueSubject<Int?, Never> = CurrentValueSubject(nil)
    
    //MARK: - Initializer
    init(movieCoordinatorDelegate: MoviesCoordinatorDelegate,
         movieDBService: MovieDBServiceProtocol,
         dataSource: CollectionViewDataSource<MoviesModel>,
         with list: MoviesList,
         with genreList: MovieGenreLists,
         currentPage: Int) {
        self.movieCoordinatorDelegate = movieCoordinatorDelegate
        self.movieDBService = movieDBService
        self.currentPage = currentPage
        self.genreList = genreList
        self.list = list
        fetchMovies(withFilter: genreList, on: currentPage)
        setUpData()
    }
    
    //MARK: - FavoriteButtonDelegate
    func buttonClicked(index sender: Int) {
        operateWithFavoriteMovies(index: sender)
    }
    
    //MARK: - Methods
    func performSearch(with searchText: String) {
        guard !searchText.isEmpty else {
            moviesArray.removeAll()
            currentOperationType = .fetchMovies
            fetchMovies(withFilter: genreList, on: currentPage)
            return
        }
        
        currentSearchText = searchText
        currentOperationType = .searchMovieByTitle
        moviesArray.removeAll()
        searchMovies(searchText, on: currentPage)
    }

    func filterMovies(_ filter: String) {
        currentOperationType = .fetchMovies
        
        switch filter {
        case Constants.mostPopularFilterButton:
            genreList = .popular
        case Constants.upComingFilterButton:
            genreList = .upComing
        case Constants.ratingFilterButton:
            genreList = .topRated
        case Constants.newestFilterButton:
            genreList = .nowPlaying
        default:
            break
        }
        
        resetToFirstPage()
    }

    func favoriteMovieListOperations(with movieID: Int, for operation: Favorites) {
        movieDBService.manageFavoritesMovies(with: movieID, for: operation)
    }
    
    func sendMovieDetails(with movieID: Int) {
        movieCoordinatorDelegate?.loadMovieDetailsView(with: movieID)
    }
    
    //MARK: - Private
    private func fetchMovies(withFilter: MovieGenreLists, on page: Int) {
        movieDBService.movieArrayCreation(operationType: .fetchMovies, with: withFilter.movieList(), for: list, page: page) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let moviesData):
                guard moviesData.totalPages > page else {
                    self.popUpMessage.send(Constants.noMorePages)
                    return }
                
                self.moviesArray.append(contentsOf: moviesData.modelResults)
                self.dataSource.items = self.moviesArray
                self.fetchingDataSuccession.send(true)
            case .failure(let error):
                self.popUpMessage.send(error.localizedDescription)
            }
        }
    }
    
    private func searchMovies(_ text: String, on page: Int) {
        movieDBService.movieArrayCreation(operationType: .searchMovieByTitle, with: text, for: list, page: page) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let moviesData):
                guard moviesData.totalPages > page else {
                    self.popUpMessage.send(Constants.noMorePages)
                    return }
                
                self.moviesArray.append(contentsOf: moviesData.modelResults)
                self.dataSource.items = self.moviesArray
                self.fetchingDataSuccession.send(true)
            case .failure(let error):
                self.popUpMessage.send(error.localizedDescription)
            }
        }
    }
    
    private func setUpData() {
        dataSource.configureCell = { [weak self] cell, indexPath, items in
            cell.delegate = self
            cell.movieIindex = indexPath.row
            cell.setMovies(with: items)
        }
        
        dataSource.didSelectItem = { [weak self] item in
            self?.sendMovieDetails(with: item.movieResults.id)
        }
        
        dataSource.changePageHandler = { [weak self] in
            self?.changePage()
        }
        
        dataSource.resetToFirstPageHandler = { [weak self] in
            self?.resetToFirstPage()
        }
    }
    
    private func operateWithFavoriteMovies(index: Int) {
        dataSource.items[index].isFavorite
        ? favoriteMovieListOperations(with: dataSource.items[index].movieResults.id, for: .removeFromFavorites)
        : favoriteMovieListOperations(with: dataSource.items[index].movieResults.id, for: .addToFavorites)
        dataSource.items[index].isFavorite.toggle()
        favoriteButtonIndex.send(index)
    }
    
    private func changePage() {
        currentPage += 1
        fetchingType()
    }
    
    private func resetToFirstPage() {
        currentPage = 1
        moviesArray.removeAll()
        resetPosition.send(true)
        fetchingType()
    }
    
    private func fetchingType() {
        switch currentOperationType {
        case .fetchMovies:
            fetchMovies(withFilter: genreList, on: currentPage)
        case .searchMovieByTitle:
            searchMovies(currentSearchText, on: currentPage)
        default:
            break
        }
    }
    
}
