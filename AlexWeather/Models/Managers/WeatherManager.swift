
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
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
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
    
    func updateWeatherInfobyCityName(cityName: String, completion: @escaping (SearchCompletionData?) -> Void) {
        guard let encodedCityName = cityName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://api.openweathermap.org/geo/1.0/direct?q=\(encodedCityName)&appid=b341573f7a5bb123a98e2addf28cba47")
        else {
            completion(nil)
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let citySearchData = try? JSONDecoder().decode([CitySearchDatum].self, from: data), let citySearch = citySearchData.first {
                let completionData = SearchCompletionData(
                    country: citySearch.country,
                    name: citySearch.name,
                    localNames: citySearch.localNames,
                    lat: citySearch.lat,
                    lon: citySearch.lon
                )
                completion(completionData)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
}

extension WeatherManager: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}


//example of API request 
//https://api.openweathermap.org/data/2.5/weather?lat=35.7020691&lon=139.7753269&appid=b341573f7a5bb123a98e2addf28cba47&units=metric
