//
//  String+Localizable.swift
//  WeatherImageOverlay
//
//  Created by Nikolay Dimitrov on 7.12.23.
//

import Foundation

extension String {

    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
