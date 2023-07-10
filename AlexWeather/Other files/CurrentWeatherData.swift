
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




















//130af965a13542537138a6ef5cc6216f
// 39°39′15″ с. ш. 66°57′35″ в. д.

//55 45    37 37

//https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}

//        https://api.openweathermap.org/data/2.5/weather?lat=39.39&lon=66.57&appid=130af965a13542537138a6ef5cc6216f


//LONDON
//https://api.openweathermap.org/data/2.5/weather?lat=51.50998&lon=-0.1337&appid=130af965a13542537138a6ef5cc6216f


//TOKYO
//https://api.openweathermap.org/data/2.5/weather?lat=35.7020691&lon=139.7753269&appid=130af965a13542537138a6ef5cc6216f




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
