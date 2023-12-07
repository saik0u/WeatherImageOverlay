//
//  UIImage+Overlay.swift
//  WeatherImageOverlay
//
//  Created by Nikolay Dimitrov on 7.12.23.
//

import UIKit

extension UIImage {

    /// Add another image as an overlay at the bottom left corner
    func overlayBottomLeftWith(image: UIImage) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)

        return renderer.image { context in
            // Draw the original image
            draw(in: CGRect(origin: .zero, size: size))

            // Calculate the position for the overlay image at the bottom-left corner
            let bottomLeftPoint = CGPoint(x: 0, y: size.height - image.size.height)
            let overlayRect = CGRect(origin: bottomLeftPoint, size: image.size)

            // Draw the overlay image
            image.draw(in: overlayRect)
        }
    }
}
