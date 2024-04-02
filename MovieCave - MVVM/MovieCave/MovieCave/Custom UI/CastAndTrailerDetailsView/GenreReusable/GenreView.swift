//
//  GenreLabel.swift
//  MovieCave
//
//  Created by Admin on 29.12.23.
//

import UIKit

struct GenreViewConstants {
    static let gerneViewFrameAdditionalWidth: CGFloat = 10
    static let gerneViewFrameHeight: CGFloat = 25
    static let genreViewLabelShadowRadius: CGFloat = 4
    static let genreViewLabelShadowOpacity: Float = 0.6
    static let genreViewLabelShadowOffset: CGSize = CGSize(width: 0, height: 4)
    static let numberOfLinesOne: Int = 1
    static let genreLabelColor: UIColor = UIColor(red: 0.98, green: 0.85, blue: 0.12, alpha: 1)
    static let additionalXpositionSizeWidth: CGFloat = 16
    static let genreLabelAdditionalFrameOriginY: CGFloat = 16
    static let additionalYposicitonSpacing: CGFloat = 32
    static let genreLabelRowPlus: Int = 1
    static let genreLabelStartingRowHighestElement: CGFloat = 0
    static let genreLabelStartingRowPosition: Int = 0
    static let genreLabelYposition: CGFloat = 8
    static let genreLabelXposition: CGFloat = 8
}

protocol GenreViewProtocol: UIView {
    
    /// Configures the view with the provided text.
    /// - Parameter text: The text to be displayed in the view.
    func configureView(text: String?)
}

class GenreView: UIView, GenreViewProtocol {
    
    //MARK: - Properties
    private var label: UILabel?
    private var text: String? {
        get {
            return label?.text
        }
        set {
            label?.text = newValue
            updateViewSize()
        }
    }
    
    //MARK: - GenreViewProtocol
    func configureView(text: String?) {
        label = UILabel(frame: CGRect.zero)
        commonInit()
        self.text = text
    }

    //MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        label?.frame = bounds
    }
    
    //MARK: - Private methods
    private func commonInit() {
        guard let label else { return }
        
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        configureLabel()
    }

    private func configureLabel() {
        guard let label else { return }
        
        label.textColor = GenreViewConstants.genreLabelColor
        label.layer.cornerRadius = bounds.height / CastViewConstants.cornerRadiusDevider
        label.textAlignment = .center
        label.numberOfLines = GenreViewConstants.numberOfLinesOne
        label.layer.shadowColor = UIColor.red.cgColor
        label.layer.shadowOffset = GenreViewConstants.genreViewLabelShadowOffset
        label.layer.shadowOpacity = GenreViewConstants.genreViewLabelShadowOpacity
        label.layer.shadowRadius = GenreViewConstants.genreViewLabelShadowRadius
    }
    
    private func updateViewSize() {
        guard let labelSize = label?.intrinsicContentSize else { return }
        
        frame.size = CGSize(width: labelSize.width + GenreViewConstants.gerneViewFrameAdditionalWidth, height: GenreViewConstants.gerneViewFrameHeight)
    }

}
