//
//  LocationInfo.swift
//  AlexWeather
//
//  Created by Alex on 30.07.2023.
//

import Foundation
import UIKit

class LocationInfo: UIView {
    
     let locationLabel: UILabel = {
        let locationLabel = UILabel()
        locationLabel.textAlignment = .center
        return locationLabel
    }()
    private let locationPinIcon = UIImageView(image: UIImage(named: Constants.Icons.locationPinIcon))
    private let searchIcon = UIImageView(image: UIImage(named: Constants.Icons.searchIcon))
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    func setupUI() {
        addSubview(locationLabel)
        locationLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(Constants.Constraints.locationLabelBottom)
            make.leading.trailing.equalToSuperview().inset(Constants.Constraints.locationLabelLeadingTrailing)
            make.height.equalTo(Constants.Constraints.locationLabelHeight)
        }
        addSubview(locationPinIcon)
        locationPinIcon.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(Constants.Constraints.locationPinIconBottom)
            make.leading.equalTo(locationLabel).inset(Constants.Constraints.locationPinIconLeading)
            make.height.equalTo(Constants.Constraints.locationLabelHeight)
        }
        addSubview(searchIcon)
        searchIcon.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(Constants.Constraints.searchIconBottom)
            make.trailing.equalTo(locationLabel).offset(Constants.Constraints.searchIconTrailing)
            make.height.equalTo(Constants.Constraints.searchIconHeight)
        }
    }
    func setLocationText(text: String) {
        locationLabel.text = text
    }
    
}

extension LocationInfo {
    enum Constants {
        enum Constraints {
            
            static let locationLabelBottom = 70
            static let locationLabelLeadingTrailing = 100
            static let locationLabelHeight = 50
            
            static let locationPinIconBottom = 80
            static let locationPinIconLeading = -30
            static let locationPinIconHeight = 20
            
            static let searchIconBottom = 80
            static let searchIconTrailing = 30
            static let searchIconHeight = 20
        }
        enum Icons {
            static let locationPinIcon = "icon_location.png"
            static let searchIcon = "icon_search.png"
        }
    }
}
