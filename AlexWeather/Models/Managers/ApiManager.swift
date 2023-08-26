//
//  ApiManager.swift
//  AlexWeather
//
//  Created by Alex on 26.08.2023.
//

import Foundation

enum ApiType {
    
    case weatherRequest
    case weatherRequestByLocation
    
    //    var baseURL: String {
    //        return "https://api.openweathermap.org/"
    //    }
    
    //    var headers: [String: String] {
    //        switch self {
    //
    //        }
    //    }
    
    //    var path: String {
    //        switch self {
    //        case .weatherRequest: return
    //        }
    //    }
    func makeRequest(latitude: Double, longitude: Double, cityName: String) {
        
//        var request: URLRequest {
            var weatherRequest = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=b341573f7a5bb123a98e2addf28cba47&units=metric"
            var weatherRequestByLocation = "https://api.openweathermap.org/geo/1.0/direct?q=\(cityName)&appid=b341573f7a5bb123a98e2addf28cba47"
//        }
        
    }
}

class ApiManager {
    
    static let shared = ApiManager()
}


//https://api.openweathermap.org/data/2.5/
//https://api.openweathermap.org/geo/1.0/direct?q=
