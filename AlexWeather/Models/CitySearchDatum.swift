//
//  CitySearchData.swift
//  AlexWeather
//
//  Created by Alex on 25.08.2023.
//

import Foundation

struct CitySearchDatum: Codable {
    let name: String
    let localNames: [String: String]
    let lat, lon: Double
    let country, state: String
    
//    let temperature: Int?
//    let weather: String?
//    let id: Int?
//    let windSpeed: Double?
//    let cod: Int?

    enum CodingKeys: String, CodingKey {
        case name
        case localNames = "local_names"
        case lat, lon, country, state
    }
}

typealias CitySearchData = [CitySearchDatum]

//struct CitySearchData: Decodable {
//    let name: String
//    let localNames: [String: String]?
//    let lat: Double
//    let lon: Double
//    let country: String
//    let state: String
//    let temperature: Int
//
//    let weather: String
//    let id: Int
//    let windSpeed: Double
//    let cod: Int
//
//    enum CodingKeys: String, CodingKey {
//        case name
//        case localNames = "local_names"
//        case lat, lon, country, state
//    }
//}
//
//typealias CitySearchData = [CitySearch]

