//
//  BulkCitySearchCompletion.swift
//  AlexWeather
//
//  Created by Alex on 30.08.2023.
//

import Foundation

struct StackCitySearchCompletion: Codable {
    let name: String
    let latitude, longitude: Double
    let country: String
    let population: Int
    let isCapital: Bool
}
