//
//  SearchViewControllerDelegate.swift
//  AlexWeather
//
//  Created by Alex on 28.09.2023.
//

import Foundation

protocol SearchViewControllerDelegate: AnyObject {
    func didSelectLocation(latitude: Double, longitude: Double)
}
