//
//  RoundedButton.swift
//  MovieCave
//
//  Created by Admin on 26.10.23.
//

import UIKit

struct RoundedButtonConstants {
    static let roundedButtonCornerRadiusDevider: CGFloat = 2
    static let roundedButtonBackgroundColor: UIColor = UIColor(red: 0.8, green: 0.9, blue: 1.0, alpha: 1.0)
    static let roundedButtonLayerShadowOffset: CGSize = CGSize(width: 0, height: 2)
    static let roundedButtonLayerShadowRadius: CGFloat = 4
    static let roundedButtonLayerShadowOpacity: Float = 0.5
}

class RoundedButton: UIButton {
    
    //MARK: - Lifecycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = bounds.height / RoundedButtonConstants.roundedButtonCornerRadiusDevider
        
        backgroundColor = RoundedButtonConstants.roundedButtonBackgroundColor
        
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOffset = RoundedButtonConstants.roundedButtonLayerShadowOffset
        layer.shadowRadius = RoundedButtonConstants.roundedButtonLayerShadowRadius
        layer.shadowOpacity = RoundedButtonConstants.roundedButtonLayerShadowOpacity
        
        addTarget(self, action: #selector(buttonPressed), for: .touchDown)
        addTarget(self, action: #selector(buttonReleased), for: .touchUpInside)
        addTarget(self, action: #selector(buttonReleased), for: .touchUpOutside)
        addTarget(self, action: #selector(buttonReleased), for: .touchCancel)
    }
    
    //MARK: - Methods
    @objc private func buttonPressed() {
        backgroundColor = UIColor.lightGray
    }
    
    @objc private func buttonReleased() {
        backgroundColor = RoundedButtonConstants.roundedButtonBackgroundColor
    }
}

