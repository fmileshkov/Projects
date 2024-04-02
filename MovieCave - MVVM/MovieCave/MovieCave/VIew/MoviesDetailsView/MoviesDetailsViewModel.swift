//
//  MovieDetailsScreenViewModel.swift
//  MovieCave
//
//  Created by Admin on 2.10.23.
//

import Foundation
import Combine

//MARK: - DetailsScreenViewModelProtocol
protocol MediaDetailsScreenViewModelProtocol {
    /// A subject that holds an array of media videos.
    var mediaVideos: CurrentValueSubject<[MediaVideos]?, Never> { get }
    
    /// A subject that holds an array of media cast members.
    var mediaCast: CurrentValueSubject<[MediaCast]?, Never> { get }
    
    /// A subject that holds the details of the media.
    var mediaDetails: CurrentValueSubject<MediaDetails?, Never> { get }
    
    /// A subject that holds the pop-up message.
    var popUpMessage: CurrentValueSubject<String?, Never> { get }
}



protocol MoviesDetailsProtocol: MediaDetailsScreenViewModelProtocol {
    /// Retrieves the details of a movie with the specified media ID and media type.
    /// - Parameters:
    ///   - mediaId: The ID of the movie.
    ///   - type: The type of media (movie, TV series).
    func movieDetails(mediaId: Int ,with type: MediaType)
}

class MoviesDetailsViewModel: MoviesDetailsProtocol {
    
    //MARK: - Properties
    var mediaDetails: CurrentValueSubject<MediaDetails?, Never> = CurrentValueSubject(nil)
    var mediaVideos: CurrentValueSubject<[MediaVideos]?, Never> = CurrentValueSubject(nil)
    var mediaCast: CurrentValueSubject<[MediaCast]?, Never> = CurrentValueSubject(nil)
    var popUpMessage: CurrentValueSubject<String?, Never> = CurrentValueSubject(nil)
    weak var movieCoordinatorDelegate: MoviesCoordinatorDelegate?
    private var apiService: MovieDBServiceProtocol
    
    //MARK: - Initializer
    init(mediaID: Int, movieDetailsViewCoordinatorDelegate: MoviesCoordinatorDelegate, apiService: MovieDBServiceProtocol, with type: MediaType) {
        self.movieCoordinatorDelegate = movieDetailsViewCoordinatorDelegate
        self.apiService = apiService
        movieDetails(mediaId: mediaID, with: type)
    }
    
    //MARK: - MoviesDetailsProtocol
    func movieDetails(mediaId: Int ,with type: MediaType) {
        fetchMovieDetails(with: "\(mediaId)")
        fetchMovieCast(with: mediaId)
        fetchMovieVideos(with: mediaId)
    }
    
    //MARK: - Methods
    private func fetchMovieDetails(with key: String) {
        apiService.operateWithAPI(type: .movies, key: "\(key)", page: 1, operationType: .fetchMovieDetails, httpMethod: .get) { [weak self] (result: Result<MovieDetailsData, MovieDBErrors>) in
            
            switch result {
            case .success(let movie):
                let movieDetails = MediaDetails(title: movie.name,
                                                overview: movie.overview,
                                                id: movie.id,
                                                poster: movie.posterPath ?? Constants.noImageString,
                                                bigPoster: movie.backdropPath ?? Constants.noImageString,
                                                avrgVote: "\(movie.voteAverage.roundedToTwoDecimalPlaces())",
                                                releaseDate: movie.firstAirDate,
                                                gernes: movie.genres.map{$0.name})
                self?.mediaDetails.send(movieDetails)
            case .failure(let error):
                self?.popUpMessage.send(error.localizedDescription)
            }
        }
    }
    
    private func fetchMovieVideos(with ID: Int) {
        apiService.operateWithAPI(type: .movies, key: "\(ID)", page: 1, operationType: .fetchMovieVideos, httpMethod: .get) { [weak self] (result: Result<MediaVideosDecoder, MovieDBErrors>) in
            
            switch result {
            case .success(let videos):
                var trailers = [MediaVideos]()
                videos.results.forEach { trailer in
                    guard trailer.type == Constants.trailerKeyWord else { return }
                    let video = MediaVideos(key: trailer.key, name: trailer.name)
                    trailers.append(video)
                }
                
                self?.mediaVideos.send(trailers)
            case .failure(let error):
                self?.popUpMessage.send(error.localizedDescription)
            }
        }
    }
    
    private func fetchMovieCast(with ID: Int) {
        apiService.operateWithAPI(type: .movies, key: "\(ID)", page: 1, operationType: .fetchMovieCast, httpMethod: .get) { [weak self] (result: Result<MediaCastDecoder, MovieDBErrors>) in
            
            switch result {
            case .success(let cast):
                var castArray = [MediaCast]()
                cast.cast.forEach {
                    let cast = MediaCast(name: $0.name, poster: $0.profilePath)
                    castArray.append(cast)
                }
                
                self?.mediaCast.send(castArray)
            case .failure(let error):
                self?.popUpMessage.send(error.localizedDescription)
            }
        }
    }
    
}
