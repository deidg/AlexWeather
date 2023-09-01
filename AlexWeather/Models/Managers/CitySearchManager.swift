//
//  CitySearchManager.swift
//  AlexWeather
//
//  Created by Alex on 24.08.2023.
//

import Foundation

   // NInja API request manager
final class CitySearchManager {
    
    func searchAllCities(cityName: String, completion: @escaping ([StackCitySearch]) -> Void) {
           guard let url = URL(string: "https://api.api-ninjas.com/v1/city?name=\(cityName)&limit=5") else {
               completion([])
               return
           }
           var request = URLRequest(url: url)
           request.setValue("GqcDeugbKzRuPNBIIZDbwQ==AAYTx0GW6GlEfyWN", forHTTPHeaderField: "X-Api-Key")
           let task = URLSession.shared.dataTask(with: request) { data, response, error in
               guard let data = data else {
                   completion([])
                   return
               }
               do {
                   let decoder = JSONDecoder()
                   let cities = try decoder.decode([StackCitySearch].self, from: data)
                   completion(cities)
               } catch {
                   print("Error decoding JSON: \(error)")
                   completion([])
               }
           }
           task.resume()
       }
    
    
    
    }
    
    
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
    
//    func searchAllCities(cityName: String, completion: @escaping ([StackCitySearch]) -> Void) {
//        guard let url = URL(string: "https://api.api-ninjas.com/v1/city?name=\(cityName)&limit=5") else {
//            completion([])
//            return
//        }
//        var request = URLRequest(url: url)
//        request.setValue("GqcDeugbKzRuPNBIIZDbwQ==AAYTx0GW6GlEfyWN", forHTTPHeaderField: "X-Api-Key")
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data else {
//                completion([])
//                return
//            }
//            do {
//                let decoder = JSONDecoder()
//                let cities = try decoder.decode([StackCitySearch].self, from: data)
//                completion(cities)
//            } catch {
//                print("Error decoding JSON: \(error)")
//                completion([])
//            }
//        }
//        task.resume()
//    }
    
//}
