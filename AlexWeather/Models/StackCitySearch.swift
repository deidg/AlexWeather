//
//  BulkCitySearch.swift
//  AlexWeather
//
//  Created by Alex on 30.08.2023.
//

import Foundation

struct StackCitySearch: Decodable {
    let name: String
    let latitude, longitude: Double
    let country: String
    let population: Int
    let isCapital: Bool
    enum CodingKeys: String, CodingKey {
        case name, latitude, longitude, country, population
        case isCapital = "is_capital"
    }
}
