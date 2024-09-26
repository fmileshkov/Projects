//
//  UIImage+Resize.swift
//  MovieCave
//
//  Created by Admin on 4.10.23.
//

import UIKit

extension UIImage {
    
    /// Resizes an image to a target size while maintaining the aspect ratio
    /// - Parameter targetSize: The size to resize the image to
    /// - Returns: A resized UIImage or nil if resizing fails
    func resizeImage(targetSize: CGSize) -> UIImage? {
            let scaledSize = aspectFill(to: targetSize)
            
            UIGraphicsBeginImageContextWithOptions(scaledSize, false, scale)
            draw(in: CGRect(origin: .zero, size: scaledSize))
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return newImage
        }
        
        private func aspectFill(to targetSize: CGSize) -> CGSize {
            let widthRatio = targetSize.width / size.width
            let heightRatio = targetSize.height / size.height
            let scaleFactor = max(widthRatio, heightRatio)
            let scaledWidth = size.width * scaleFactor
            let scaledHeight = size.height * scaleFactor
            return CGSize(width: scaledWidth, height: scaledHeight)
        }
    
}
