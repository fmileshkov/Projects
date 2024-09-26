//
//  GenresView.swift
//  MovieCave
//
//  Created by Admin on 13.01.24.
//

import UIKit

protocol GenreLabelsViewProtocol: UIView {
    
    /// Sets up genre labels based on the provided genres.
    /// - Parameter genres: An array of strings representing the genres.
    func setUpGenreLabels(with genres: [String])
}

class GenreLabelsView: UIView, GenreLabelsViewProtocol {
    
    //MARK: - Properties
    private var genreLabels: [GenreViewProtocol] = []
    
    //MARK: - Public Methods
    func setUpGenreLabels(with genres: [String]) {
        
        var xPosition: CGFloat = GenreViewConstants.genreLabelXposition
        var yPosition: CGFloat = GenreViewConstants.genreLabelYposition
        var row = GenreViewConstants.genreLabelStartingRowPosition
        var currentRowHighestElement: CGFloat = GenreViewConstants.genreLabelStartingRowHighestElement
        
        genres.forEach { genre in
            let genreLabel: GenreViewProtocol = GenreView()
            genreLabel.configureView(text: genre)
            
            if genreLabel.frame.size.height > currentRowHighestElement {
                currentRowHighestElement = genreLabel.frame.size.height
            }
            
            if genreLabel.frame.width >= frame.size.width - xPosition {
                row += GenreViewConstants.genreLabelRowPlus
                yPosition += currentRowHighestElement + GenreViewConstants.additionalYposicitonSpacing
                xPosition = GenreViewConstants.genreLabelXposition
                currentRowHighestElement = GenreViewConstants.genreLabelStartingRowHighestElement
            }
            
            genreLabel.frame.origin = CGPoint(x: xPosition, y: yPosition + GenreViewConstants.genreLabelAdditionalFrameOriginY)
            
            addSubview(genreLabel)
            genreLabels.append(genreLabel)
            
            xPosition += genreLabel.frame.size.width + GenreViewConstants.additionalXpositionSizeWidth
        }
    }

}

