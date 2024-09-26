//
//  Double+Rounded+TwoPlaces.swift
//  MovieCave
//
//  Created by Admin on 4.10.23.
//

import Foundation

extension Double {
    
    /// Rounds the double value to two decimal places.
    /// - Returns: The double value rounded to two decimal places.
    func roundedToTwoDecimalPlaces() -> Double {
        return (self * 100).rounded() / 100
    }
}
