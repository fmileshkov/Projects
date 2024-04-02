//
//  CollectionViewCell.swift
//  MovieCave
//
//  Created by Admin on 28.09.23.
//

import UIKit

struct CollectionViewReusableCellConstants {
    static let reusableCellFavoriteButtonFrame: CGRect = CGRect(x:1, y:1, width:35,height:35)
    static let collectionViewReusableCellLayerCornerRadius: CGFloat = 10
    static let collectionViewReusableCellLayerBorderWidth: CGFloat = 2
}

protocol CollectionViewReusableCellProtocolForSeries {
    
    /// Configures the cell to display data for a TV show.
    /// - Parameter series: The TV show data to display.
    func setTVSeries(with series: TVSeriesResults)
}

protocol CollectionViewReusableCellProtocolForMovies{
    
    /// Configures the cell to display data for a movie.
    /// - Parameter movies: The movie data to display.
    func setMovies(with movies: MovieModelResults)
}

protocol FavoriteButtonDelegate: AnyObject {
    
    /// Tells the delegate that the favorite button was clicked for the item at the given index.
    /// - Parameter index: The index of the item whose favorite button was clicked.
    func buttonClicked(index: Int)
}

class CollectionViewReusableCell: UICollectionViewCell, CollectionViewReusableCellProtocolForSeries, CollectionViewReusableCellProtocolForMovies {
    
    //MARK: - Properties
    weak var delegate: FavoriteButtonDelegate?
    private var favoriteButton: UIButton!
    private let emptyStar = UIImage(systemName: Constants.starImage)?
        .resizeSystemImage(sizeChange: CGSize(width: ReusableListViewConstants.systemIconWidht, height: ReusableListViewConstants.systemIconHeight), tintColor: .systemYellow)
    private let filledStar = UIImage(systemName: Constants.starFillImage)?
        .resizeSystemImage(sizeChange: CGSize(width: ReusableListViewConstants.systemIconWidht, height: ReusableListViewConstants.systemIconHeight), tintColor: .systemYellow)
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    var movieIindex: Int?
    
    func setTVSeries(with series: TVSeriesResults) {
        imageView.downloaded(from: ReusableListViewConstants.moviePosterURL + (series.posterPath ?? Constants.noImageString), contentMode: .scaleAspectFit)
    }
    
    func setMovies(with movie: MovieModelResults) {
        favortieStarButtonChange(movie: movie)
        imageView.downloaded(from: ReusableListViewConstants.moviePosterURL + (movie.movieResults.posterPath ?? Constants.noImageString), contentMode: .scaleAspectFit)
    }
    
    func setUpFavoriteButtonDelegate(for delegate: FavoriteButtonDelegate) {
        self.delegate = delegate
    }

    //MARK: - Initiaizers
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.borderWidth = CollectionViewReusableCellConstants.collectionViewReusableCellLayerBorderWidth
        layer.cornerRadius = CollectionViewReusableCellConstants.collectionViewReusableCellLayerCornerRadius
        clipsToBounds = true
        contentView.addSubview(imageView)
        contentView.clipsToBounds = true
        
        favoriteButton = UIButton(frame: CollectionViewReusableCellConstants.reusableCellFavoriteButtonFrame)
        favoriteButton.addTarget(self, action: #selector(self.favoriteButtonTapped), for: .touchUpInside)
        self.addSubview(favoriteButton)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - Override Methods
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    //MARK: - Private methods
    private func favortieStarButtonChange(movie: MovieModelResults) {
        DispatchQueue.main.async {
            movie.isFavorite
            ? self.favoriteButton.setImage(self.filledStar, for: .normal)
            : self.favoriteButton.setImage(self.emptyStar, for: .normal)
        }
    }
    
    @objc private func favoriteButtonTapped(_ sender: UIButton) {
        guard let movieIindex else { return }
        
        delegate?.buttonClicked(index: movieIindex)
    }
    
}
