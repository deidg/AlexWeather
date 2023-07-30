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
}WeatherInfoView

extension WeatherInfoView {
    enum Constants {
        enum Text {
            static let labelTextColor = UIColor(red: 102/255, green: 178/255, blue: 255/255, alpha: 1)
            static let temperatureLabelFontName = "SFProDisplay-Bold"
            static let temperatureLabelFontSize: CGFloat = 83
            static let conditionsLabelFontName = "Ubuntu-Regular"
            static let conditionsLabelFontSize: CGFloat = 36
        }
        enum Shadows {
            static let infoButtonShadowOpacity: Float = 1
            static let infoButtonShadowOffsetWidth = 2
            static let infoButtonShadowOffsetHeight = 2
            static let infoButtonShadowShadowRadius: CGFloat = 1
            static let infoButtonShadowCornerRadius: CGFloat = 15
        }
        enum Constraints {
            static let contentViewTopBottomOffset = -60
            static let stoneImageViewTopOffset = -570
            
            static let temperatureLabelBottom = 300
            static let temperatureLabelLeading = 20
            static let temperatureLabelTrailing = 200
            static let temperatureLabelHeight = 100
            
            static let conditionsLabelToTop = 250//100
            static let conditionsLabelBottomLeading = 20
            static let conditionsLabelBottomTrailing = 100
            static let conditionsLabelBottomHeight = 50
            
            static let locationLabelBottom = 70
            static let locationLabelLeadingTrailing = 100
            static let locationLabelHeight = 50
            
            static let infoButtonShadowViewBottom = -20
            static let infoButtonShadowViewLeadingTrailing = 100
            static let infoButtonShadowViewHeight = 70
            
            static let infoButtonBottom = -20
            static let infoButtonLeadingTrailing = 100
            static let infoButtonHeight = 70
            
            static let locationPinIconBottom = 80
            static let locationPinIconLeading = -30
            static let locationPinIconHeight = 20
            
            static let searchIconBottom = 80
            static let searchIconTrailing = 30
            static let searchIconHeight = 20
            
            //            ======
            
            static let infoLargeViewDepthTop = 100
            static let infoLargeViewDepthLeading = 80
            static let infoLargeViewDepthTrailing = 40
            static let infoLargeViewDepthHeight = 400
            
            static let infoLargeViewTop = 100
            static let infoLargeViewLeadingTrailing = 60
            static let infoLargeViewHeight = 400
            
            static let infoLargeViewTitleLabelLeadingTrailing = 30
            static let infoLargeViewTitleLabelTop = 30
            
            static let infoLargeViewLabelLeadingTrailing = 30
            static let infoLargeViewLabelTop = 10
            static let infoLargeViewLabelHeight = 300
            
            static let infoLargeViewHideButtonLeadingTrailing = 30
            static let infoLargeViewHideButtonTop = 5
            
        }
        enum Conditions {
            static let windSpeedLimit = 3.0
            static let alphaStandart = 1.0
            static let alphaMist = 0.3
            static let temprature = 30
        }
        enum Stones {
            static let normalStoneImage = "image_stone_normal.png"
            static let wetStoneImage = "image_stone_wet.png"
            static let snowStoneImage = "image_stone_snow.png"
            static let cracksStoneImage = "image_stone_cracks.png"
        }
        enum Icons {
            static let locationPinIcon = "icon_location.png"
            static let searchIcon = "icon_search.png"
        }
        enum Images {
            static let backgroundView = UIImageView(image: UIImage(named: "image_background.png"))
        }
        enum Borders {
            static let frameBorderColor = UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1).cgColor
        }
        enum Colors {
            static let mainBackgroundColor = UIColor(red: 160/255, green: 160/255, blue: 160/255, alpha: 1)
            static let firstCellBackgroundColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1)
        }
        
        //        ===========
        //    TODO: убрать из названий large
        enum setupInfoView {
            static let backgroundView = UIImageView(image: UIImage(named: "image_background.png"))
            static let infoLargeViewBackgroundColor = UIColor(red: 255/255, green: 153/255, blue: 96/255, alpha: 1)
            static let infoLargeViewCornerRadius: CGFloat = 25
            static let infoLargeViewShadowColor = UIColor.black.cgColor
            static let infoLargeViewShadowOpacity: Float = 0.2
            static let infoLargeViewShadowOffsetWidth = 0
            static let infoLargeViewShadowOffsetHeight = 10
            static let infoLargeViewShadowRadius: CGFloat = 10
            
            static let infoLargeViewDepthBackgroundColor = UIColor (red: 251/255, green: 95/255, blue: 41/255, alpha: 1)
            static let infoLargeViewDepthCornerRadius: CGFloat = 25
            static let infoLargeViewDepthShadowColor = UIColor.black.cgColor
            static let infoLargeViewDepthShadowOpacity: Float = 0.2
            static let infoLargeViewDepthShadowOffset = CGSize(width: 0, height: 10)
            static let infoLargeViewDepthShadowRadius:CGFloat = 10
            
            static let infoLargeViewTitleLabelText = "INFO"
            static let infoLargeViewLabelAttributedString = NSMutableAttributedString(string: "Brick is wet - raining \nBrick is dry - sunny \nBrick is hard to see - fog \nBrick with cracks - very hot \nBrick with snow - snow \nBrick is swinging - windy \nBrick is gone - No Internet")
            static let infoLargeViewLabelNumberOfLines = 7
            static let infoLargeViewLabelLineSPacing: CGFloat = 10
            
            static let infoButtonShadowFrame = UIView(frame: CGRect(x: 110, y: 800, width: 175, height: 85))
            static let infoButtonShadowShadowOpacity: Float = 0.2
            static let infoButtonShadowShadowOffset = CGSize(width: 10, height: 5)
            static let infoButtonShadowShadowRadius: CGFloat = 5
            static let infoButtonShadowCornerRadius: CGFloat = 15
            
            static let infoLargeViewHideButtonTitle = "Hide"
            static let infoLargeViewHideButtonTitleColor = UIColor(red: 87/255, green: 87/255, blue: 87/255, alpha: 1)
            static let infoLargeViewHideButtonBorderColor = UIColor(red: 87/255, green: 87/255, blue: 87/255, alpha: 1).cgColor
            static let infoLargeViewHideButtonBorderWidth:CGFloat = 1.5
            static let infoLargeViewHideButtonCornerRaidus:CGFloat = 15
        }
    }
}
