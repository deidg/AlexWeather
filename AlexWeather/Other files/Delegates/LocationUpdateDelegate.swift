//
//  LocationUpdateDelegate.swift
//  AlexWeather
//
//  Created by Alex on 20.08.2023.
//

import Foundation

protocol LocationUpdateDelegate: AnyObject {
    func updateLocation(latitude: Double, longitude: Double)
}
