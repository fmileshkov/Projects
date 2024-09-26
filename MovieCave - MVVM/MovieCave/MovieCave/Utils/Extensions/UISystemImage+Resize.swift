//
//  UIImage+Resize.swift
//  MovieCave
//
//  Created by Admin on 28.09.23.
//

import Foundation
import UIKit

extension UIImage {
    
    /// Resizes the image to the specified size and applies a tint color.
    /// - Parameters:
    ///   - sizeChange: The new size for the image.
    ///   - tintColor: The tint color to apply to the image.
    /// - Returns: The resized and tinted image.
    func resizeSystemImage(sizeChange: CGSize, tintColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(sizeChange, false, 0)
        tintColor.set() // set tint color
        draw(in: CGRect(origin: .zero, size: sizeChange))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        resizedImage.withRenderingMode(.alwaysTemplate)
        
        return resizedImage.withTintColor(tintColor)
    
    }
    
}
