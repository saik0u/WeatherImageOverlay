//
//  WeatherResponse.swift
//  WeatherImageOverlay
//
//  Created by Nikolay Dimitrov on 6.12.23.
//

struct WeatherResponse: Codable {

    let lat: Double
    let lon: Double
    let data: [DailyWeather]
}

struct DailyWeather: Codable {

    let dt: Double
    let temp: Double
    let weather: [DailyWeatherInfo]
}

struct DailyWeatherInfo: Codable {

    let main: String
    let icon: String
}
