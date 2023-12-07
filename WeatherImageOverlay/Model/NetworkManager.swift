//
//  NetworkManager.swift
//  WeatherImageOverlay
//
//  Created by Nikolay Dimitrov on 6.12.23.
//

import Foundation

typealias Coordinates = (latitude: String, longitude: String)

protocol NetworkManagerProtocol {

    func fetchWeatherData(coordinates: Coordinates, timestamp: String, completion: @escaping (Result<WeatherResponse, Error>) -> Void)
}

struct NetworkManager: NetworkManagerProtocol {

    func fetchWeatherData(coordinates: Coordinates, timestamp: String, completion: @escaping (Result<WeatherResponse, Error>) -> Void) {

        // TODO: Refactor using URLComponents
        let url = API.base
        + API.timemachine
        + "?lat=\(coordinates.latitude)"
        + "&lon=\(coordinates.longitude)"
        + "&dt=\(timestamp)"
        + "&units=metric"
        + "&appid=\(API.apiKey)"

        guard let url = URL(string: url) else {
            completion(.failure(NetworkError.badURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error {
                completion(.failure(error))
            }

            guard let data else {
                completion(.failure(NetworkError.dataError))
                return
            }

            do {
                let decodedData = try JSONDecoder().decode(WeatherResponse.self, from: data)
                completion(.success(decodedData))
            }
            catch {
                completion(.failure(error))
            }
        }
        .resume()
    }
}
