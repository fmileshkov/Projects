//
//  TvSeriesDetailsViewModel.swift
//  MovieCave
//
//  Created by Admin on 11.01.24.
//

import Foundation
import Combine

protocol TvSeriesDetailsProtocol: MediaDetailsScreenViewModelProtocol {
    /// Retrieves the details of a TV series with the specified media ID and media type.
    /// - Parameters:
    ///   - mediaId: The ID of the TV series.
    ///   - type: The type of media (TV series, movie).
    func tvSeriesDetails(mediaId: Int ,with type: MediaType)
}

class TvSeriesDetailsViewModel: TvSeriesDetailsProtocol {
    
    //MARK: - Properties
    var mediaVideos: CurrentValueSubject<[MediaVideos]?, Never> = CurrentValueSubject(nil)
    var mediaCast: CurrentValueSubject<[MediaCast]?, Never> = CurrentValueSubject(nil)
    var mediaDetails: CurrentValueSubject<MediaDetails?, Never> = CurrentValueSubject(nil)
    var popUpMessage: CurrentValueSubject<String?, Never> = CurrentValueSubject(nil)
    weak var tvSeriesCoordinatorDelegate: TVSeriesCoordinatorDelegate?
    private var apiService: MovieDBServiceProtocol
    
    //MARK: - Initializer
    init(mediaID: Int, tvSeriesCoordinatorDelegate: TVSeriesCoordinatorDelegate, apiService: MovieDBServiceProtocol, with type: MediaType) {
        self.tvSeriesCoordinatorDelegate = tvSeriesCoordinatorDelegate
        self.apiService = apiService
        tvSeriesDetails(mediaId: mediaID, with: type)
    }
    
    //MARK: - TvSeriesDetailsProtocol
    func tvSeriesDetails(mediaId: Int ,with type: MediaType) {
        fetchTVSeriesDetails(with: "\(mediaId)")
        fetchTVSeriesCast(with: mediaId)
        fetchTVSeriesVideos(with: mediaId)
    }
    
    //MARK: - Private
    private func fetchTVSeriesDetails(with key: String) {
        apiService.operateWithAPI(type: .tvSeries, key: "\(key)", page: 1, operationType: .fetchSeriesDetails, httpMethod: .get) { [weak self] (result: Result<TVSeriesDetailsData, MovieDBErrors>) in
            
            switch result {
            case .success(let series):
                let seriesDetails = MediaDetails(title: series.name,
                                                 overview: series.overview,
                                                 id: series.id,
                                                 poster: series.posterPath ?? Constants.noImageString,
                                                 bigPoster: series.backdropPath ?? Constants.noImageString,
                                                 avrgVote: "\(series.voteAverage.roundedToTwoDecimalPlaces())",
                                                 releaseDate: series.firstAirDate,
                                                 gernes: series.genres.map{$0.name})
                self?.mediaDetails.send(seriesDetails)
            case .failure(let error):
                self?.popUpMessage.send(error.localizedDescription)
            }
        }
    }
    
    private func fetchTVSeriesVideos(with ID: Int) {
        apiService.operateWithAPI(type: .tvSeries, key: "\(ID)", page: 1, operationType: .fetchSeriesVideos, httpMethod: .get) { [weak self] (result: Result<MediaVideosDecoder, MovieDBErrors>) in
            
            switch result {
            case .success(let videos):
                var trailers: [MediaVideos] = []
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
    
    private func fetchTVSeriesCast(with ID: Int) {
        apiService.operateWithAPI(type: .tvSeries, key: "\(ID)", page: 1, operationType: .fetchSeriesCast, httpMethod: .get) { [weak self] (result: Result<MediaCastDecoder, MovieDBErrors>) in
            
            switch result {
            case .success(let cast):
                var castArray: [MediaCast] = []
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
