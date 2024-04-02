//
//  AddMovieViewModel.swift
//  MovieCave
//
//  Created by Admin on 27.09.23.
//

import Foundation
import Combine

//MARK: - TVSeriesViewModelProtocol
protocol TVSeriesViewModelProtocol {
    /// Filters the TV series based on the specified genre.
    /// - Parameter genre: The genre to filter the TV series by.
    func filterSeries(_ genre: String)
    
    /// Sends the details of a TV series with the specified movie ID.
    /// - Parameter movieID: The ID of the TV series to retrieve details for.
    func sendSeriesDetails(with movieID: Int)
    
    /// Performs a search with the specified search text.
    /// - Parameter searchText: The text to search for.
    func performSearch(with searchText: String)
    
    /// A current value publisher representing the succession state of data fetching.
    var fetchingDataSuccession: CurrentValueSubject<Bool, Never> { get }
    
    /// A subject that holds the pop-up message.
    var popUpMessage: CurrentValueSubject<String?, Never> { get }
    
    /// A subject that holds the reset position flag.
    var resetPosition: CurrentValueSubject<Bool, Never> { get }
    
    /// The data source for the collection view.
    var dataSource: CollectionViewDataSource<TVSeriesResults> { get }
}

class TVSeriesViewModel: TVSeriesViewModelProtocol {
    
    //MARK: - Properties
    private weak var tvSeriesViewCoordinatorDelegate: TVSeriesCoordinatorDelegate?
    private let movieDBService: MovieDBServiceProtocol
    private var currentPage: Int
    private var list: TVSeriesLists
    private var seriesArray: [TVSeriesResults] = []
    private var currentSearchText: String = ""
    private var currentOperationType: APIOperations = .fetchSeries
    var fetchingDataSuccession: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)
    var popUpMessage: CurrentValueSubject<String?, Never> = CurrentValueSubject(nil)
    var resetPosition: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)
    let dataSource = CollectionViewDataSource<TVSeriesResults>(items: [])
    
    //MARK: - Initializer
    init(tvSeriesViewCoordinatorDelegate: TVSeriesCoordinatorDelegate, movieDBService: MovieDBServiceProtocol, currentPage: Int, list: TVSeriesLists) {
        self.tvSeriesViewCoordinatorDelegate = tvSeriesViewCoordinatorDelegate
        self.movieDBService = movieDBService
        self.currentPage = currentPage
        self.list = list
        fetchSeries(withFilter: list, on: currentPage)
        setUpData()
    }
    
    //MARK: - Methods
    func performSearch(with searchText: String) {
        guard !searchText.isEmpty else {
            seriesArray.removeAll()
            currentOperationType = .fetchSeries
            fetchSeries(withFilter: list, on: currentPage)
            return
        }
        
        seriesArray.removeAll()
        currentSearchText = searchText
        currentOperationType = .searchSeriesByTitle
        searchTVSeries(with: searchText, on: currentPage)
    }
    
    func filterSeries(_ filter: String) {
        currentOperationType = .fetchSeries
        
        switch filter {
        case Constants.popularTVSeriesFilterButton:
            list = .popular
        case Constants.airingTodayTVSeriesFilterButton:
            list = .airingToday
        case Constants.topRatedTVSeriesFilterButton:
            list = .topRated
        case Constants.onTheAirTVSeriesFilterButton:
            list = .onTheAir
        default:
            break
        }
        
        resetToFirstPage()
    }

    func sendSeriesDetails(with seriesID: Int) {
        tvSeriesViewCoordinatorDelegate?.loadSeriesDetailsView(with: seriesID)
    }

    //MARK: - Private
    private func fetchSeries(withFilter: TVSeriesLists, on page: Int) {
        movieDBService.tvSeriesArrayCreation(with: withFilter.tvSeriesList(), on: page, operationType: .fetchSeries) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let series):
                guard series.totalPages > page else {
                    self.popUpMessage.send(Constants.noMorePages)
                    return }
                
                self.seriesArray.append(contentsOf: series.results)
                self.dataSource.items = self.seriesArray
                self.fetchingDataSuccession.send(true)
            case .failure(let error):
                self.popUpMessage.send(error.localizedDescription)
            }
        }
    }
    
    private func searchTVSeries(with query: String, on page: Int) {
        movieDBService.tvSeriesArrayCreation(with: query, on: page, operationType: .searchSeriesByTitle) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let series):
                guard series.totalPages > page else {
                    self.popUpMessage.send(Constants.noMorePages)
                    return
                }
                
                self.seriesArray.append(contentsOf: series.results)
                self.dataSource.items = self.seriesArray
                self.fetchingDataSuccession.send(true)
            case .failure(let error):
                self.popUpMessage.send(error.localizedDescription)
            }
        }
    }
    
    private func changePage() {
        currentPage += 1
        fetchingType()
    }

    private func resetToFirstPage() {
        currentPage = 1
        seriesArray.removeAll()
        resetPosition.send(true)
        fetchingType()
    }
    
    private func fetchingType() {
        switch currentOperationType {
        case .fetchSeries:
            fetchSeries(withFilter: list, on: currentPage)
        case .searchSeriesByTitle:
            searchTVSeries(with: currentSearchText, on: currentPage)
        default:
            break
        }
    }
    
    private func setUpData() {
        dataSource.configureCell = { [weak self] cell, indexPath, items in
            cell.setTVSeries(with: items)
        }
        
        dataSource.didSelectItem = { [weak self] item in
            self?.sendSeriesDetails(with: item.id)
        }
        
        dataSource.changePageHandler = { [weak self] in
            self?.changePage()
        }
        
        dataSource.resetToFirstPageHandler = { [weak self] in
            self?.resetToFirstPage()
        }
    }
    
}
