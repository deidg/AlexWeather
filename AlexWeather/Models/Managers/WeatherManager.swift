
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
    
    func updateWeatherInfobyCityName(cityName: String, completion: @escaping (SearchCompletionData) -> Void) {
        guard let encodedCityName = cityName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://api.openweathermap.org/geo/1.0/direct?q=\(encodedCityName)&appid=b341573f7a5bb123a98e2addf28cba47")
        else {
            return
        }
        queue.async {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data, let citySearchData = try? JSONDecoder().decode(CitySearchData.self, from: data) {
                    if let firstCity = citySearchData.first {
                        DispatchQueue.main.async {
                            let completionData = SearchCompletionData(
                                country: firstCity.country,
                                name: firstCity.name,
                                localNames: firstCity.localNames,
                                lat: firstCity.lat,
                                lon: firstCity.lon,
                                temperature: 0, // Update with appropriate data
                                weather: "", // Update with appropriate data
                                id: 0, // Update with appropriate data
                                windSpeed: 0.0, // Update with appropriate data
                                cod: 0 // Update with appropriate data
                            )
                            completion(completionData)
                        }
                    }
                }
            }
            task.resume()
        }
    }
}

    
    
    
    
    
    
    
    
    
//    private let queue = DispatchQueue(label: "CitySearchManager_working_queue", qos: .userInitiated)
//    func updateWeatherInfobyCityName(cityName: String,
//                         completion: @escaping (SearchCompletionData) -> Void) {
//        guard let url = URL(string: "https://api.openweathermap.org/geo/1.0/direct?q=\(cityName)&appid=b341573f7a5bb123a98e2addf28cba47") else {
//            return
//        }
//        queue.async {
//            let task = URLSession.shared.dataTask(with: url) { data, response, error in
//                if let data = data, let citySearchData = try? JSONDecoder().decode([CitySearchData].self, from: data) {
//                    if let firstCity = citySearchData.first {
//                        DispatchQueue.main.async {
//                            let completionData = SearchCompletionData(
//                                country: firstCity.country,
//                                city: firstCity.name
//                                weather:
//                                id:
//                                windSpeed:
//                                cod:
//
//                            )
//                            completion(completionData)
//                        }
//                    }
//                }
//            }
//            task.resume()
//        }
//    }
//
//
//
//}

extension WeatherManager: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
