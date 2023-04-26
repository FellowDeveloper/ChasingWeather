//
//  WeatherModels.swift
//  ChasingWeather
//
//  Created by Anton Tugolukov on 4/21/23.
//

import Foundation



// For the sake of simplicity these structs are extracted 1:1 from JSON response
// Would be nice to only extract what is needed and flatten the response

struct NamedWeatherReport: Codable {
    let report: WeatherReport
    let created: Date
    let name: String
}

struct WeatherReport : Codable {
    let coord: Coordinate
    let weather: [WeatherInfo]
    let main: MainWeatherInfo
    let wind: WindInfo
    let sys: SunsetSunrizeInfo
}

struct MainWeatherInfo : Codable {
    let temp: Double
    let feelsLike: Double
    let pressure: Int
    let humidity: Int
}

struct WindInfo : Codable {
    let speed : Double
    let deg: Int
    let gust: Double?
}

struct SunsetSunrizeInfo : Codable {
    let country: String
    let sunrise: Int
    let sunset: Int
}

struct Coordinate : Codable {
    let lat: Double
    let lon: Double
}

struct WeatherInfo: Codable {
    let id: Int
    let main: String
    let description: String
    let icon : String
}


