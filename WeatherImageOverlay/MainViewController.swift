//
//  MainViewController.swift
//  WeatherImageOverlay
//
//  Created by Nikolay Dimitrov on 5.12.23.
//

import Foundation
import PhotosUI

class MainViewController: UIViewController {

    @IBOutlet private weak var photoImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func showPhotoPicker() {
        var configuration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        configuration.filter = .images

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }

    func reverseGeocodeLocation(coordinate: CLLocationCoordinate2D) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let geocoder = CLGeocoder()

        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Reverse geocoding failed with error: \(error.localizedDescription)")
                return
            }

            if let placemark = placemarks?.first,
               let city = placemark.locality {
                print("Location Name: \(city)")
            }
            else {
                print("City information not available.")
            }
        }
    }

    @IBAction private func selectPhotoButtonTapped(_ sender: Any) {
        showPhotoPicker()
    }
}

// MARK: - PHPickerViewControllerDelegate
extension MainViewController: PHPickerViewControllerDelegate {

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        defer {
            picker.dismiss(animated: true, completion: nil)
        }

        guard let selectedImageResult = results.first else {
            print("No image selected.")
            return
        }

        // Get the photo asset metadata like Date and Location Coordinates
        if let assetId = selectedImageResult.assetIdentifier {
            let assetResults = PHAsset.fetchAssets(withLocalIdentifiers: [assetId], options: nil)

            print(assetResults.firstObject?.creationDate ?? "No date")
            print(assetResults.firstObject?.location?.coordinate ?? "No location")

            if let coords = assetResults.firstObject?.location?.coordinate {
                reverseGeocodeLocation(coordinate: coords)
            }
        }

        // Get the UIImage
        if selectedImageResult.itemProvider.canLoadObject(ofClass: UIImage.self) {
            selectedImageResult.itemProvider.loadObject(ofClass: UIImage.self) { (selectedImage, error) in
                if let error = error {
                    print(error.localizedDescription)
                } 
                else {
                    DispatchQueue.main.async { [weak self] in
                        self?.photoImageView.image = selectedImage as? UIImage
                    }
                }
            }
        }
    }

    func pickerDidCancel(_ picker: PHPickerViewController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
