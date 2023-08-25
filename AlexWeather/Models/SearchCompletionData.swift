//
//  SearchCompletionData.swift
//  AlexWeather
//
//  Created by Alex on 25.08.2023.
//

import Foundation

struct CompletionData {
    let country: String
    let name: String
    
    let localNames: [String: String]?
    
    let lat: Double
    let lon: Double
    
    
    let temperature: Int
    let weather: String
    let id: Int
    let windSpeed: Double
    let cod: Int
}
