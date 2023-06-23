//
//  WeatherManager.swift
//  AlexWeather
//
//  Created by Vladyslav Nhuien on 20.06.2023.
//




import Foundation

final class WeatherManager {
    private let queue = DispatchQueue(label: "WeatherManager_working_queue", qos: .userInitiated)
    
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
