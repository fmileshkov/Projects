//
//  TrailerVideosView.swift
//  MovieCave
//
//  Created by Admin on 13.01.24.
//

import UIKit

protocol TrailerVideosViewProtocol: UIStackView {
    
    /// Sets up trailer views based on the provided trailers and delegate.
    /// - Parameters:
    ///   - trailers: An array of `MediaVideos` representing the trailers.
    ///   - trailerViewDelegate: An instance conforming to `TrailerViewDelegate` to handle trailer view actions.
    func setUpTrailers(with trailers: [MediaVideos], trailerViewDelegate: TrailerViewDelegate)
}
class TrailerVideosView: UIStackView, TrailerVideosViewProtocol {
    
    //MARK: - Properties
    private var trailerViews = [TrailerView]()
    
    //MARK: - Public Methods
    func setUpTrailers(with trailers: [MediaVideos], trailerViewDelegate: TrailerViewDelegate) {
        spacing = TrailerViewConstants.trailerVideosViewSpacing
        for video in trailers {
            let trailerView = TrailerView()
            trailerView.configureView(videoKey: video.key, labelText: video.name)
            trailerView.delegate = trailerViewDelegate
            addArrangedSubview(trailerView)
        }
    }
    
}
