//
//  NetworkManager.swift
//  AlexWeather
//
//  Created by Alex on 20.05.2023.
//

import Foundation
//import UIKit



//TODO:  сократить parseJSON и оптимизировать apiRequest по видео от яндекса. https://www.youtube.com/watch?v=Ba3SeP6E3j8&list=TLPQMjAwNjIwMjPY0vqMHIFdCA&index=2


 final class NetworkManager {
    
    private let queue =  DispatchQueue(label: "NetworkManager_working_queue", qos: .userInitiated)
    
    func getWeatherInfo(latitude: Double,
                        longitude: Double,
                        completion: ((CompletionData) -> Void)?) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=130af965a13542537138a6ef5cc6216f&units=metric") else { return }
        queue.async {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data, let weather = try? JSONDecoder().decode(CurrentWeatherData.self, from: data) {
                    DispatchQueue.main.async {
                        let complitionData = CompletionData(temp: Int(weather.main.temp),
                                                            id: weather.weather.first?.id ?? 0,
                                                            weather: weather.weather.first?.description ?? "",
                                                            windSpeed: weather.wind.speed,
                                                            cityName: weather.name)
                        completion?(complitionData)
                    }
                }
            }
            task.resume()
        }
    }
}

struct CompletionData {
    let temp: Int
    let id: Int
    let weather: String
    let windSpeed: Double
    let cityName: String
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
