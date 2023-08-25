//
//  CitySearchData.swift
//  AlexWeather
//
//  Created by Alex on 25.08.2023.
//

import Foundation

struct CitySearchData: Codable {
    let name: String
    let localNames: [String: String]?
    let lat, lon: Double
    let country, state: String

    enum CodingKeys: String, CodingKey {
        case name
        case localNames = "local_names"
        case lat, lon, country, state
    }
}
