//
//  CitySearchData.swift
//  AlexWeather
//
//  Created by Alex on 25.08.2023.
//

import Foundation

struct CitySearch: Codable {
    let name: String
    let localNames: [String: String]?
    let lat: Double
    let lon: Double
    let country: String
    let state: String

    enum CodingKeys: String, CodingKey {
        case name
        case localNames = "local_names"
        case lat, lon, country, state
    }
}

typealias CitySearchData = [CitySearch]

