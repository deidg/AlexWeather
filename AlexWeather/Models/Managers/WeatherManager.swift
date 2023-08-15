////
////  WeatherManager.swift
////  WeatherApplication
////
////  Created by MacBook on 01.08.2023.
////
//
//import Foundation
//
//final class WeatherManager {
//    let queue = DispatchQueue(label: "WeatherManager_queue_working...", qos: .userInitiated)
//    //MARK: Singleton
//    static var shared = WeatherManager()
//
//    private init() {}
//    //MARK: Methods
//    func updateWeatherInfo(latitude: Double, longitude: Double, completion: ((CompletionData) -> Void)?) {
//        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=b341573f7a5bb123a98e2addf28cba47&units=metric") else { return }
//        queue.async {
//            let task = URLSession.shared.dataTask(with: url) { data, responce, error in
//                if let data = data,
//                   let weather = try? JSONDecoder().decode(WeatherData.self, from: data) {
//                    DispatchQueue.main.async {
//                        let completionData = CompletionData(city: weather.name,
//                                                            country: weather.sys.country,
//                                                            temperature: Int(weather.main.temp),
//                                                            weather: weather.weather.first?.main ?? "",
//                                                            id: weather.weather.first?.id ?? 0,
//                                                            windSpeed: weather.wind.speed,
//                                                            cod: weather.cod)
//                        completion?(completionData)
//                    }
//                }
//            }
//            task.resume()
//        }
//    }
//}
////MARK: - NSCopying
//extension WeatherManager: NSCopying {
//    func copy(with zone: NSZone? = nil) -> Any {
//        return self
//    }
//}












import Foundation

final class WeatherManager {
    private let queue = DispatchQueue(label: "WeatherManager_working_queue", qos: .userInitiated)
    //MARK: Singleton
    static var shared = WeatherManager()

    private init() {}

    func updateWeatherInfo(latitude: Double,
                           longitude: Double,
                           completion: ((CompletionData) -> Void)?) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=b341573f7a5bb123a98e2addf28cba47&units=metric") else { return }
        queue.async {
            let task = URLSession.shared.dataTask(with: url) { data, responce, error in
                if let data = data, let weather = try? JSONDecoder().decode(WeatherData.self, from: data) {
                    DispatchQueue.main.async {
                    let completionData = CompletionData(
                        city: weather.name,
                        country: weather.sys.country,
                        temperature: Int(weather.main.temp),
                        weather: weather.weather.first?.main ?? "",
                        id: weather.weather.first?.id ?? 0,
                        windSpeed: weather.wind.speed,
                        cod: weather.cod)
                        completion?(completionData)
                    }
                }
            }
            task.resume()
        }
    }
}

extension WeatherManager: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
