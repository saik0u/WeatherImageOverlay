//
//  WeatherOverlayViewModel.swift
//  WeatherImageOverlay
//
//  Created by Nikolay Dimitrov on 7.12.23.
//

import Foundation
import UIKit

struct WeatherOverlayViewModel {

    let cityName: String
    let iconName: String
    let temp: String

    init(cityName: String?, iconName: String?, temp: Double?) {
        self.cityName = cityName ?? "n/a"
        self.iconName = iconName ?? "placeholderPhoto"
        if let temp {
            self.temp = String(temp) + "º"
        }
        else {
            self.temp = "n/a º"
        }
    }

    func getIcon() -> UIImage {
        // TODO: Add proper night icons
        // or download the images from the weather API

        if iconName == "01d" || iconName == "01n",
           let icon = UIImage(named: "01d_clear") {
            return icon
        }
        else if iconName == "02d" || iconName == "02n",
                let icon = UIImage(named: "02d_few_clouds") {
            return icon
        }
        else if iconName == "03d" || iconName == "03n",
                let icon = UIImage(named: "03d_scattered_clouds") {
            return icon
        }
        else if iconName == "04d" || iconName == "04n",
                let icon = UIImage(named: "04d_broken_clouds") {
            return icon
        }
        else if iconName == "09d" || iconName == "09n",
                let icon = UIImage(named: "09d_shower_rain") {
            return icon
        }
        else if iconName == "10d" || iconName == "10n",
                let icon = UIImage(named: "10d_rain") {
            return icon
        }
        else if iconName == "11d" || iconName == "11n",
                let icon = UIImage(named: "11d_thunderstorm") {
            return icon
        }
        else if iconName == "13d" || iconName == "13n",
                let icon = UIImage(named: "13d_snow") {
            return icon
        }
        else if iconName == "50d" || iconName == "50n",
                let icon = UIImage(named: "50d_mist") {
            return icon
        }

        return UIImage(named: iconName)!
    }
}
