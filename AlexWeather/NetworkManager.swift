//
//  NetworkManager.swift
//  AlexWeather
//
//  Created by Alex on 20.05.2023.
//

import Foundation
import UIKit

struct NetworkManager {
    
    func apiRequest(latitude: Double, longitude: Double, completionHandler: @escaping (CurrentWeather) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)"
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if let data = data {
                if let currentWeather = parseJSON(withData: data) {  //.self?
                    //                completionHandler(latitude: <#T##Double#>, longitude: <#T##Double#>, completionHandler: <#T##CurrentWeather#>)
                    completionHandler(currentWeather)
                }
            }
            
        }
        task.resume()
    }
    
    func parseJSON(withData data: Data) -> CurrentWeather? {
        let decoder = JSONDecoder()
        do {
            let currentWeatherData = try decoder.decode(CurrentWeatherData.self, from: data)
            
            guard let currentWeather = CurrentWeather(currentWeatherData: currentWeatherData)
            else {
                return nil
            }
            return currentWeather
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
}

//130af965a13542537138a6ef5cc6216f
// 39°39′15″ с. ш. 66°57′35″ в. д.

//https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}

//        https://api.openweathermap.org/data/2.5/weather?lat=39.39&lon=66.57&appid=130af965a13542537138a6ef5cc6216f
