//
//  CurrentWeather.swift
//  AlexWeather
//
//  Created by Alex on 20.05.2023.
//

import Foundation

struct CurrentWeather {
    
    let temperature: Double
    var temperatureString: String {
        return "\(temperature.rounded())"
    }
    let conditionCode: Int
    let conditionDescription: String // condition code
    
    let cityName: String  //  name?
//    let countryName: String
    
    init?(currentWeatherData: CurrentWeatherData) {
        
        temperature = currentWeatherData.main.temp
        conditionCode = currentWeatherData.weather.first!.id
        conditionDescription = currentWeatherData.weather.first!.description
        
        cityName = currentWeatherData.name
//        countryName = currentWeatherData.sys.init(country: countryName)
    }
}
