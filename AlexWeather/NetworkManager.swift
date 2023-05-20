//
//  NetworkManager.swift
//  AlexWeather
//
//  Created by Alex on 20.05.2023.
//

import Foundation
import UIKit

struct NetworkManager {

    func apiRequest(latitude: Double, longitude: Double) { // установка города 8.41  ч 5
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=130af965a13542537138a6ef5cc6216f"
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if let data = data {
                let dataString = String(data: data, encoding: .utf8)
                print(dataString ?? "")
            }
        }
        task.resume()
    }
}



//130af965a13542537138a6ef5cc6216f
// 39°39′15″ с. ш. 66°57′35″ в. д.

//https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}

//        https://api.openweathermap.org/data/2.5/weather?lat=39.39&lon=66.57&appid=130af965a13542537138a6ef5cc6216f
