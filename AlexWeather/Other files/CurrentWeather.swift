//
//  CurrentWeather.swift
//  AlexWeather
//
//  Created by Alex on 20.05.2023.
//

import Foundation

struct CurrentWeather {
    
    let temperature: Int // раньше Double
    var temperatureString: String {
        return String(format: "%.0f", temperature)
    }
    let conditionCode: Int
    let conditionDescription: String
    let windSpeed: Double
    
    let cityName: String
    let countryName: String
    
    init?(currentWeatherData: CurrentWeatherData) {
        temperature = currentWeatherData.main.temp
        conditionCode = currentWeatherData.weather.first?.id ?? 0 //раньше был ! //conditionCode //?? 0
        conditionDescription = currentWeatherData.weather.first!.description // ?? ""
        windSpeed = currentWeatherData.wind.speed
        
        cityName = currentWeatherData.name
        countryName = currentWeatherData.sys.country
    }
}
