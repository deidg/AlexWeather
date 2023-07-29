//
//  WeatherInfoView.swift
//  AlexWeather
//
//  Created by Alex on 29.07.2023.
//

import Foundation
import UIKit

class WeatherInfoView: UIView {
    
    private let temperatureLabel: UILabel = {
        let temperatureLabel = UILabel()
        temperatureLabel.font = UIFont(name: Constants.Text.temperatureLabelFontName, size: Constants.Text.temperatureLabelFontSize)
        temperatureLabel.textColor = .black
        temperatureLabel.textAlignment = .left
        return temperatureLabel
    }()
    
    private let conditionsLabel: UILabel = {
        let conditionsLabel = UILabel()
        conditionsLabel.textColor = .black
        conditionsLabel.font = UIFont(name: Constants.Text.conditionsLabelFontName, size: Constants.Text.conditionsLabelFontSize)
        return conditionsLabel
    }()
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    private func setupUI() {
        addSubview(temperatureLabel)
        temperatureLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(Constants.Constraints.temperatureLabelBottom)
            make.leading.equalToSuperview().inset(Constants.Constraints.temperatureLabelLeading)
            make.trailing.equalToSuperview().inset(Constants.Constraints.temperatureLabelTrailing)
        }
        addSubview(conditionsLabel)
        conditionsLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(Constants.Constraints.conditionsLabelToTop)
            make.leading.equalToSuperview().inset(Constants.Constraints.conditionsLabelBottomLeading)
            make.trailing.equalToSuperview().inset(Constants.Constraints.conditionsLabelBottomTrailing)
            make.height.equalTo(Constants.Constraints.conditionsLabelBottomHeight)
        }
    }
    func setTemperature(temperature: String) {
        temperatureLabel.text = temperature
    }
    
    func setConditions(conditions: String) {
        conditionsLabel.text = conditions
    }
}

