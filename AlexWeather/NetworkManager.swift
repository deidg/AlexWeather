//
//  NetworkManager.swift
//  AlexWeather
//
//  Created by Alex on 20.05.2023.
//

import Foundation
import UIKit

struct NetworkManager {

    func apiRequest(latitude: Double, longitude: Double) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)"
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if let data = data {
                parseJSON(withData: data)  //.self?
            }
        }
        task.resume()
    }
}

func parseJSON(withData data: Data) {
    let decoder = JSONDecoder()
    do {
        let currentWeatherData = try decoder.decode(CurrentWeatherData.self, from: data)
        print(currentWeatherData)
    } catch let error as NSError {
        print(error.localizedDescription)
    }
   
}


//130af965a13542537138a6ef5cc6216f
// 39°39′15″ с. ш. 66°57′35″ в. д.

//https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}

//        https://api.openweathermap.org/data/2.5/weather?lat=39.39&lon=66.57&appid=130af965a13542537138a6ef5cc6216f
