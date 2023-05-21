//
//  CurrentWeatherData.swift
//  AlexWeather
//
//  Created by Alex on 20.05.2023.
//

import Foundation

//температура - main - temp
//описание - weather - id
//город - name
    //страна - country


struct CurrentWeatherData: Codable {
    
    let main: Main
    let weather: [Weather]
    
    let name: String
    let sys: Sys
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let id: Int
    let description: String
}

struct Sys: Codable {
    let country: String
}

//=============
//struct CurrentWeatherData: Decodable {
//
//    let name: String
//    let main: Main
//    let weather: [Weather]
//}
//
//struct Main: Decodable {
//    let temp: Double
//    let main: String
////    let feelsLike: Double
////
////    enum CodingKeys: String, CodingKey {
////        case temp
//////        case description
////        case feelsLike = "feels_like"
////    }
//}
//
//struct Weather: Decodable {
//    let id: Int
//    let description: String
//    let weather: String
//}












