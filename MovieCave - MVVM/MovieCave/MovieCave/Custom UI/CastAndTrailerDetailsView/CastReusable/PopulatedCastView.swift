//
//  PopulatedCastView.swift
//  MovieCave
//
//  Created by Admin on 13.01.24.
//

import UIKit

protocol PopulatedCastViewProtocol: UIStackView {
    
    /// Sets up cast views based on the provided cast members.
    /// - Parameter cast: An array of `MediaCast` representing the cast members.
    func setUpCast(with cast: [MediaCast])
}

class PopulatedCastView: UIStackView, PopulatedCastViewProtocol {
    
    //MARK: - Properties
    private var castViews: [TrailerView] = []
    
    //MARK: - Public Methods
    func setUpCast(with cast: [MediaCast]) {
        spacing = CastViewConstants.castViewSpacing
        for actor in cast {
            guard let castPoster = actor.poster else { return }
            
            let cast = CastView()
            cast.configureView(posterKey: castPoster, castName: actor.name)
            addArrangedSubview(cast)
        }
    }
    
    //MARK: - Private
    private func removeAllCast() {
        for genreLabel in castViews {
            genreLabel.removeFromSuperview()
        }

        castViews.removeAll()
    }
}
