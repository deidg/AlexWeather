//
//  NetworkManager.swift
//  AlexWeather
//
//  Created by Alex on 20.05.2023.
//

import Foundation
import UIKit
import CoreLocation


//TODO:  сократить parseJSON и оптимизировать apiRequest по видео от яндекса. https://www.youtube.com/watch?v=Ba3SeP6E3j8&list=TLPQMjAwNjIwMjPY0vqMHIFdCA&index=2


class NetworkManager {
    
    var onComletion: ((CurrentWeather) -> Void)?
    
    func apiRequest(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if let data = data {
                if let currentWeather = self.parseJSON(withData: data) {
                    self.onComletion?(currentWeather)
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
            print(error)
        }
        return nil
    }
}
// вставить в функцию в конце комплишн, чтобы после получения данных выполнялся код. Пример есть в прошлом задании V3. т.е на главном меню вызывается экземпляр класса Network manager и у него используется комплишн (на основании данных которые получает сам NetworkManager



//130af965a13542537138a6ef5cc6216f
// 39°39′15″ с. ш. 66°57′35″ в. д.

//55 45    37 37

//https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}

//        https://api.openweathermap.org/data/2.5/weather?lat=39.39&lon=66.57&appid=130af965a13542537138a6ef5cc6216f


//LONDON
//https://api.openweathermap.org/data/2.5/weather?lat=51.50998&lon=-0.1337&appid=130af965a13542537138a6ef5cc6216f


//TOKYO
//https://api.openweathermap.org/data/2.5/weather?lat=35.7020691&lon=139.7753269&appid=130af965a13542537138a6ef5cc6216f


//Mumbai
//https://api.openweathermap.org/data/2.5/weather?lat=19.0176147&lon=72.8561644&appid=130af965a13542537138a6ef5cc6216f
