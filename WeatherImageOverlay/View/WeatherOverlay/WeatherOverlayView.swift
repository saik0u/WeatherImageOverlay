//
//  WeatherOverlayView.swift
//  WeatherImageOverlay
//
//  Created by Nikolay Dimitrov on 7.12.23.
//

import UIKit

class WeatherOverlayView: ReusableXibView {

    @IBOutlet private weak var cityNameLabel: UILabel!
    @IBOutlet private weak var weatherIconImageView: UIImageView!
    @IBOutlet private weak var tempLabel: UILabel!

    func configure(with viewModel: WeatherOverlayViewModel) {
        cityNameLabel.text = viewModel.cityName
        weatherIconImageView.image = viewModel.getIcon()
        tempLabel.text = viewModel.temp
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // Adjust font size after the frame update
        cityNameLabel.font = cityNameLabel.font.withSize(cityNameLabel.frame.height * 2/3)
        tempLabel.font = tempLabel.font.withSize(tempLabel.frame.height * 2/3)
    }
}
