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

    // TODO: inject dependencies
    private let geocoder = CLGeocoder()
    private let networkManager = NetworkManager()

    private var city: String?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Ask user for permission to access the photo library
        PHPhotoLibrary.requestAuthorization(for: PHAccessLevel.readWrite) { status in
            switch status {
                case .denied, .restricted, .notDetermined:
                    DispatchQueue.main.async { [weak self] in
                        self?.showAlert(title: LocalizedString.alertTitleNoAccess, message: LocalizedString.alertTitleNoAccess)
                    }
                default:
                    break
            }
        }
    }

    // MARK: - Private
    private func showPhotoPicker() {
        var configuration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        configuration.filter = .images

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }

    private func reverseGeocodeLocation(coordinate: CLLocationCoordinate2D?) {
        guard let coordinate else {
            showAlert(title: LocalizedString.alertTitlePickAnother, message: LocalizedString.alertMsgNoLocation)
            return
        }

        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            if let error {
                self?.showAlert(title: LocalizedString.somethingHappened, message: error.localizedDescription)
                return
            }

            self?.city = placemarks?.first?.locality
        }
    }

    private func requestWeatherData(coordinate: CLLocationCoordinate2D?, date: Date?) {
        guard let coordinate,
              let date
        else {
            showAlert(title: LocalizedString.alertTitlePickAnother, message: LocalizedString.alertMsgNoLocation)
            return
        }

        let coord = (String(coordinate.latitude), String(coordinate.longitude))
        let timestamp = String(Int(date.timeIntervalSince1970))

        // TODO: Add a progress spinner while we are waiting for the data
        networkManager.fetchWeatherData(coordinates: coord, timestamp: timestamp) { [weak self] result in

            switch result {
                case .success(let weatherData):
                    self?.createOverlay(from: weatherData)

                case .failure(let error):
                    self?.showAlert(title: LocalizedString.somethingHappened, message: error.localizedDescription)
            }
        }
    }

    private func createOverlay(from data: WeatherResponse?) {
        let city = city
        let icon = data?.data.first?.weather.first?.icon
        var temp = data?.data.first?.temp

        let overlayViewModel = WeatherOverlayViewModel(cityName: city, iconName: icon, temp: temp)

        DispatchQueue.main.async { [weak self] in
            guard let self,
                  let originalImageWidth = self.photoImageView.image?.size.width,
                  let originalImageHeight = self.photoImageView.image?.size.height
            else {
                return
            }

            // Create the WeatherOverlayView
            let overlayView = WeatherOverlayView()
            overlayView.configure(with: overlayViewModel)

            // Update its frame to fit the original image
            let maxSize = min(originalImageWidth / 3, originalImageHeight / 3)
            let frame = CGRect(x: 0, y: 0, width: maxSize, height: maxSize)
            overlayView.frame = frame
            overlayView.layoutIfNeeded()

            // Convert it to a UIImage and overlay them
            let overlayImage = overlayView.asImage()
            let compositeImage = self.photoImageView.image?.overlayBottomLeftWith(image: overlayImage)

            self.photoImageView.image = compositeImage
        }
    }

    // MARK: - Actions
    @IBAction private func selectPhotoButtonTapped(_ sender: Any) {
        showPhotoPicker()
    }
}

// MARK: - PHPickerViewControllerDelegate
extension MainViewController: PHPickerViewControllerDelegate {

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)

        guard let selectedImageResult = results.first else {
            showAlert(title: LocalizedString.noImage, message: "")
            return
        }

        // Get the photo asset metadata like Date and Location Coordinates
        if let assetId = selectedImageResult.assetIdentifier {
            let assetResults = PHAsset.fetchAssets(withLocalIdentifiers: [assetId], options: nil)

            reverseGeocodeLocation(coordinate: assetResults.firstObject?.location?.coordinate)
            requestWeatherData(coordinate: assetResults.firstObject?.location?.coordinate, date: assetResults.firstObject?.creationDate)
        }

        // Get the UIImage and set it
        if selectedImageResult.itemProvider.canLoadObject(ofClass: UIImage.self) {
            selectedImageResult.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (selectedImage, error) in
                guard let image = selectedImage as? UIImage else {
                    self?.showAlert(title: LocalizedString.somethingHappened, message: error?.localizedDescription ?? LocalizedString.alertTitlePickAnother)
                    return
                }

                DispatchQueue.main.async { [weak self] in
                    self?.photoImageView.image = image
                }
            }
        }
    }

    func pickerDidCancel(_ picker: PHPickerViewController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
