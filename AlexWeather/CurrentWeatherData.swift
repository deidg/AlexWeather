//
//  CurrentWeatherData.swift
//  AlexWeather
//
//  Created by Alex on 20.05.2023.
//

import Foundation

struct CurrentWeatherData: Decodable {
    
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable {
    let temp: Double
//    let feelsLike: Double
//    
//    enum CodingKeys: String, CodingKey {
//        case temp
////        case description
//        case feelsLike = "feels_like"
//    }
}

struct Weather: Decodable {
    let id: Int
    let description: String
}








