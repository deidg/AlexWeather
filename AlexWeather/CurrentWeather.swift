//
//  CurrentWeather.swift
//  AlexWeather
//
//  Created by Alex on 20.05.2023.
//

import Foundation

struct CurrentWeather {
    let cityName: String  //  name?
    
    let temperature: Double
    var temperatureString: String {
        return "\(temperature.rounded())"
    }
    
    let description: String

    init?(currentWeatherData: CurrentWeatherData) {
        cityName = currentWeatherData.name
        temperature = currentWeatherData.main.temp
//        description = currentWeatherData.main.main
    }
}
