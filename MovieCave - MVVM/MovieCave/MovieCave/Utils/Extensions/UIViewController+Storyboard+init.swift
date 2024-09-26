//
//  UIViewController+Storyboard+init.swift
//  MovieCave
//
//  Created by Admin on 20.09.23.
//

import UIKit

extension UIViewController {
    
    /// instanciateFromStoryBoard
    /// - Parameter name: Name of the storyboard
    /// - Returns: Storyboard
    static func initFromStoryBoard(_ storyBoardName: String = "Main") -> Self? {
        let storyboard = UIStoryboard(name: storyBoardName, bundle: nil)
        let controller =
        storyboard.instantiateViewController(withIdentifier: String(describing: self))
        return controller as? Self
    }

}
