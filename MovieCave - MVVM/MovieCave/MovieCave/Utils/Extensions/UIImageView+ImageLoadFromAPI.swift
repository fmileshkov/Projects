//
//  UIImageView+ImageLoadFromAPI.swift
//  MovieCave
//
//  Created by Admin on 28.09.23.
//

import UIKit

extension UIImageView {

    private func download(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self?.image = UIImage(named: "no_image_avil")
                }
                return
            }
            
            guard
                let httpURLResponse = response as? HTTPURLResponse,
                httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType,
                mimeType.hasPrefix("image"),
                let data = data,
                let image = UIImage(data: data)
            else {
                DispatchQueue.main.async {
                    self?.image = UIImage(named: "no_image_avil")
                }
                return
            }
            
            DispatchQueue.main.async {
                self?.image = image
            }
        }.resume()
    }
    
    /// Downloads an image from the specified URL string and sets it as the content of the image view.
    /// If the URL is not valid or an error occurs during download, it sets a default image from your app's assets.
    /// - Parameters:
    ///   - link: The URL string from which to download the image.
    ///   - mode: The desired content mode for the image view.
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else {
            // Set the default image from your app's assets
            self.image = UIImage(named: "no_image_avil")
            return
        }
        download(from: url, contentMode: mode)
    }
}
