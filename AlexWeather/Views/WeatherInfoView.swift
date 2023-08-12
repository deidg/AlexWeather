//
//  WeatherInfoView.swift
//  AlexWeather
//
//  Created by Alex on 29.07.2023.
//

import UIKit
import SnapKit

final class WeatherInfoView: UIView {
    var viewData: ViewData? {
        didSet {
            temperatureLabel.text = viewData?.temp
            conditionsLabel.text = viewData?.weather
            locationLabel.text = viewData?.city
        }
    }
    
     let temperatureLabel: UILabel = {
        let temperatureLabel = UILabel()
        temperatureLabel.font = UIFont(name: Constants.Text.temperatureLabelFontName, size: Constants.Text.temperatureLabelFontSize)
        temperatureLabel.textColor = .black
        temperatureLabel.textAlignment = .left
        return temperatureLabel
    }()
    
     let conditionsLabel: UILabel = {
        let conditionsLabel = UILabel()
        conditionsLabel.textColor = .black
        conditionsLabel.font = UIFont(name: Constants.Text.conditionsLabelFontName, size: Constants.Text.conditionsLabelFontSize)
        return conditionsLabel
    }()
    //TODO: проверить текст и настройки лейбла
    let locationLabe: UILabel = {
        let locationLabe = UILabel()
        locationLabe.textColor = .black
        locationLabe.font = .systemFont(ofSize: 17)
        return locationLabe
    }()
    private let locationImageView = UIImageView(image: UIImage(named: "icon_location"))
    private let searchImageView = UIImageView(image: UIImage(named: "icon_search"))
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
       ТУТ остановился
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

extension WeatherInfoView {
    enum Constants {
        enum Text {
            static let temperatureLabelFontName = "SFProDisplay-Bold"
            static let temperatureLabelFontSize: CGFloat = 83
            static let conditionsLabelFontName = "Ubuntu-Regular"
            static let conditionsLabelFontSize: CGFloat = 36
        }
        enum Constraints {
            static let temperatureLabelBottom = 300
            static let temperatureLabelLeading = 20
            static let temperatureLabelTrailing = 200
            static let temperatureLabelHeight = 100
            
            static let conditionsLabelToTop = 250//100
            static let conditionsLabelBottomLeading = 20
            static let conditionsLabelBottomTrailing = 100
            static let conditionsLabelBottomHeight = 50
        }
    }
     
   
}
