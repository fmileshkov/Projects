//
//  CastView.swift
//  MovieCave
//
//  Created by Admin on 30.12.23.
//

import UIKit

struct CastViewConstants {
    static let castViewWidhtConstraint: CGFloat = 70
    static let cornerRadiusDevider: CGFloat = 2
    static let labelNumberOfLinesZero: Int = 0
    static let imageViewLayerBorderWidth: CGFloat = 2.0
    static let castImageViewHeightAnchor: CGFloat = 70
    static let labelHeightAnchor: CGFloat = 50
    static let firstPage: Int = 1
    static let castViewSpacing: CGFloat = 8
}

protocol CastViewProtocol: AnyObject {
    /// Configures the view with a width constraint, poster image key, and cast member name.
    /// - Parameters:
    ///   - widhtConstraint: The constraint to use for the view's width.
    ///   - posterKey: The image key to use for the cast member's poster.
    ///   - castName: The name of the cast member to display.
    func configureView(posterKey: String, castName: String)
}

class CastView: UIView, CastViewProtocol {
    
    //MARK: - Properties
    private let imageView = UIImageView()
    private let label = UILabel()
    
    //MARK: - CastViewProtocol
    func configureView(posterKey: String, castName: String) {
        setUpView()
        setUpImageView(for: posterKey)
        setUpLabel(for: castName)
    }
    
    //MARK: - Private
    private func setUpView() {
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        layer.masksToBounds = true
        widthAnchor.constraint(equalToConstant: CastViewConstants.castViewWidhtConstraint).isActive = true
        addSubview(label)
        addSubview(imageView)
    }
    
    private func setUpImageView(for posterKey: String) {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: CastViewConstants.castImageViewHeightAnchor).isActive = true
        imageView.layer.borderWidth = CastViewConstants.imageViewLayerBorderWidth
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.downloaded(from: ReusableListViewConstants.moviePosterURL + posterKey)
    }
    
    private func setUpLabel(for castName: String) {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: CastViewConstants.labelHeightAnchor).isActive = true
        label.topAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        label.numberOfLines = Constants.labelNumberOfLinesZero
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.textColor = .white
        label.text = castName
    }
    
    //MARK: - Override Methods
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = imageView.frame.size.width / CastViewConstants.cornerRadiusDevider
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.opaqueSeparator.cgColor
    }
}
