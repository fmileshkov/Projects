//
//  label.swift
//  MovieCave
//
//  Created by Admin on 26.10.23.
//

import UIKit

struct BubblyLabelConstants {
    static let bubblyLabelCornerRadiusDevider: CGFloat = 2
    static let bubblyLabelBackgroundColor: UIColor = UIColor(red: 0.8, green: 0.9, blue: 1.0, alpha: 1.0)
    static let bubblyLabelLayerShadowOffset: CGSize = CGSize(width: 0, height: 2)
    static let bubblyLabelLayerShadowRadius: CGFloat = 4
    static let bubblyLabelLayerShadowOpacity: Float = 0.5
}

class BubblyLabel: UILabel {
    
    //MARK: - Lifecycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = bounds.height / BubblyLabelConstants.bubblyLabelCornerRadiusDevider
        backgroundColor = BubblyLabelConstants.bubblyLabelBackgroundColor

        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOffset = BubblyLabelConstants.bubblyLabelLayerShadowOffset
        layer.shadowRadius = BubblyLabelConstants.bubblyLabelLayerShadowRadius
        layer.shadowOpacity = BubblyLabelConstants.bubblyLabelLayerShadowOpacity
    }
}
