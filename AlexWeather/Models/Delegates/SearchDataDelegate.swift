//
//  SearchDataDelegate.swift
//  AlexWeather
//
//  Created by Alex on 19.08.2023.
//

import Foundation

protocol SearchDataDelegate: AnyObject {
    func transferSearchData (_ cityName: String)
}
