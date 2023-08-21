//
//  LocationButton.swift
//  AlexWeather
//
//  Created by Alex on 16.08.2023.
//

import UIKit
import SnapKit

final class LocationButton: UIButton {
    // MARK: Elements
    weak var delegate: LocationUpdateDelegate?
    
    // MARK: Inits
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        defaultConfiguration()
//        addTarget(self, action: #selector(updateLocation), for: .touchUpInside)
    }
    required init?(coder: NSCoder) {
                return nil
    }
    // MARK: Methods
    func defaultConfiguration() {
        setImage(UIImage(named: "icon_location"), for: UIControl.State.normal)
    }
    
//    @objc private func updateLocation() {
//
//        let latitude = 37.77
//        let longitude = -122.41
//
//        delegate?.updateLocation(latitude: latitude, longitude: longitude)
//    }
}
