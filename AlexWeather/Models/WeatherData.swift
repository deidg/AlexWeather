//
//  WeatherData.swift
//  AlexWeather
//
//  Created by Alex on 12.08.2023.
//

import Foundation

struct WeatherData: Codable {
    var name: String
    var sys: Sys
    var weather: [Weather]
    var main: Main
    var wind: Wind
    var cod: Int
}
struct Weather: Codable {
    var id: Int
    var main: String
}
struct Sys: Codable {
    var country: String
}
struct Wind: Codable {
    var speed: Double
}
struct Main: Codable {
    var temp: Double
}
struct Cod: Codable {
    var cod: Int
}
