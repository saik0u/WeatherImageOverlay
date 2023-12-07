//
//  UIViewController+Alert.swift
//  WeatherImageOverlay
//
//  Created by Nikolay Dimitrov on 6.12.23.
//

import UIKit

extension UIViewController {

    func showAlert(title: String, message: String, completion: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: LocalizedString.ok, style: .cancel, handler: completion))

        present(alert, animated: true, completion: nil)
    }
}
