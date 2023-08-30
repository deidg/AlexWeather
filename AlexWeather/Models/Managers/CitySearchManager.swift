//
//  CitySearchManager.swift
//  AlexWeather
//
//  Created by Alex on 24.08.2023.
//

import Foundation


final class CitySearchManager {
    
    func searchAllCities(cityName: String) {
        
        guard let url = URL(string: "https://api.api-ninjas.com/v1/city?name=\(cityName)&limit=5") else { return }
        var request = URLRequest(url: url)
        request.setValue("GqcDeugbKzRuPNBIIZDbwQ==AAYTx0GW6GlEfyWN", forHTTPHeaderField: "X-Api-Key")
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
        }
        task.resume()
    }
    
}
//    private let queue = DispatchQueue(label: "CitySearchManager_working_queue", qos: .userInitiated)
//    func cityNameRequest(cityName: String,
//                         completion: @escaping (CompletionData) -> Void) {
//        guard let url = URL(string: "https://api.openweathermap.org/geo/1.0/direct?q=\(cityName)&appid=b341573f7a5bb123a98e2addf28cba47") else {
//            return
//        }
//        queue.async {
//            let task = URLSession.shared.dataTask(with: url) { data, response, error in
//                if let data = data, let citySearchData = try? JSONDecoder().decode([CitySearchData].self, from: data) {
//                    if let firstCity = citySearchData.first {
//                        DispatchQueue.main.async {
//                            let completionData = CompletionData(
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
