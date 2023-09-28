//
//  WeatherInfoView.swift
//  AlexWeather
//
//  Created by Alex on 29.07.2023.
//

// TODO: удалить searchView,?

import UIKit
import SnapKit

final class WeatherInfoView: UIView {
    // MARK: Elements
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
    private let locationLabel: UILabel = {
        let locationLabel = UILabel()
        locationLabel.textColor = .black
        locationLabel.text = "Home"
        locationLabel.font = .systemFont(ofSize: 23)
        return locationLabel
    }()
    private let locationImageView = UIImageView(image: UIImage(named: "icon_location"))
    // MARK: Inits
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    required init?(coder: NSCoder) {
        return nil
    }
    // MARK: Methods
    private func setupUI() {
        addSubview(temperatureLabel)
        temperatureLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        addSubview(conditionsLabel)
        conditionsLabel.snp.makeConstraints { make in
            make.top.equalTo(temperatureLabel.snp.bottom)
            make.leading.equalToSuperview()
        }
        addSubview(locationLabel)
        locationLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(conditionsLabel.snp.bottom).offset(50)
            make.bottom.equalToSuperview()
        }
    }
}
// MARK: Extension
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
