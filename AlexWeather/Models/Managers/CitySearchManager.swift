//
//  CitySearchManager.swift
//  AlexWeather
//
//  Created by Alex on 24.08.2023.
//

import Foundation


final class CitySearchManager {
    private let queue = DispatchQueue(label: "WeatherManager_working_queue", qos: .userInitiated)
    
    
    func cityNameRquest(cityName: String,
                        completion: @escaping (SearchCompletionData) -> Void) {
        
//        let cityName = cityName
        guard let url = URL(string: "https://api.openweathermap.org/geo/1.0/direct?q=cityName&appid=b341573f7a5bb123a98e2addf28cba47") else { return }
        queue.async {
            let task = URLSession.shared.dataTask(with: url) { data, responce, error in
                if let data = data, let weather = try? JSONDecoder().decode(CitySearchData.self, from: data) {
                    DispatchQueue.main.async {
                        let completionData = CompletionData(
                            country: weather.country,
                            name: weather.name,
                            
                            
                         
                        completion(SearchCompletionData)
                    }
                }
            }
            task.resume()
            print("str37")
        }
    }
}
//    func updateWeatherInfo(latitude: Double,
//                           longitude: Double,
//                           completion: ((CompletionData) -> Void)?) {
//        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=b341573f7a5bb123a98e2addf28cba47&units=metric") else { return }
//        queue.async {
//            let task = URLSession.shared.dataTask(with: url) { data, responce, error in
//                if let data = data, let weather = try? JSONDecoder().decode(WeatherData.self, from: data) {
//                    DispatchQueue.main.async {
//                    let completionData = CompletionData(
//                        city: weather.name,
//                        country: weather.sys.country,
//                        temperature: Int(weather.main.temp),
//                        weather: weather.weather.first?.main ?? "",
//                        id: weather.weather.first?.id ?? 0,
//                        windSpeed: weather.wind.speed,
//                        cod: weather.cod)
//                        completion?(completionData)
//                    }
//                }
//            }
//            task.resume()
//        }
//    }
//


//}


