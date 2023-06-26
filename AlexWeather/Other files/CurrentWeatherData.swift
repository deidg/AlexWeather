
import Foundation

struct Weather: Codable {
    var id: Int
    var main: String
}

struct Wind: Codable {
    var speed: Double
}

struct Main: Codable {
    var temp: Double
}

struct WeatherData: Codable {
    var name: String
    var weather: [Weather]
    var main: Main
    var wind: Wind
}



////
////  CurrentWeatherData.swift
////  AlexWeather
////
////  Created by Alex on 20.05.2023.
////
//
//import Foundation
//
////температура - main - temp
////описание - weather - id
////windSpeed - скорость ветра
////город - name
//    //страна - country
//
//struct CurrentWeatherData: Codable {
//
//    let main: Main
//    let weather: [Weather]
//    let wind: Wind
//
//    let name: String
//    let sys: Sys
//}
//
//struct Main: Codable {
//    let temp: Int
//}
//
//struct Weather: Codable {
//    let id: Int //conditionCode: Int
//    let description: String
//}
//
//struct Sys: Codable {
//    let country: String
//}
//
//struct Wind: Codable {
//    let speed: Double
//}
//
//
//// weather conditons
////https://openweathermap.org/weather-conditions
