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


//    let temperature: Int
//    let weather: String
//    let id: Int
//    let windSpeed: Double
//    let cod: Int
}

//struct SearchCompletionData: Codable {
//    let name: String?
//    let localNames: [String: String]?
//    let lat: Double?
//    let lon: Double?
//    let country: String?
//    let state: String?
//
//
//    enum CodingKeys: String, CodingKey {
//        case name
//        case localNames = "local_names"
//        case lat, lon, country, state
//    }
//}
//
//typealias CitySearchData = [SearchCompletionData]
