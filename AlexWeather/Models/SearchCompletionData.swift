//
//  SearchCompletionData.swift
//  AlexWeather
//
//  Created by Alex on 25.08.2023.
//

import Foundation

struct SearchCompletionData: Codable {
    let country: String
    let name: String
    let localNames: [String: String]?
    let lat: Double
    let lon: Double
}


