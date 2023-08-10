//
//  InfoView.swift
//  AlexWeather
//
//  Created by Alex on 27.07.2023.
//


// TODO: поменять название на DescriptionView

import Foundation
import UIKit

protocol DescriptionViewDelegate: AnyObject {
    func hideInfo()
}


class DescriptionView: UIView {
    
    weak var delegate: DescriptionViewDelegate?

    //MARK: elements
//    let mainViewController = MainViewController()
    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height
    private let backgroundView: UIImageView = {
        let backgroundView = Constants.Images.backgroundView
        backgroundView.contentMode = .scaleAspectFill
        return backgroundView
    }()
    
    private let infoConditionsView: UIView = {   //сам большой экран с текстом
        var infoConditionsView = UIView()
        
        infoConditionsView.backgroundColor = .blue // Constants.setupInfoLargeView.backgroundView
        infoConditionsView.contentMode = .scaleAspectFill
        //настройка тени
        infoConditionsView.backgroundColor = Constants.setupInfoView.infoLargeViewBackgroundColor
        infoConditionsView.layer.cornerRadius = Constants.setupInfoView.infoLargeViewCornerRadius
        infoConditionsView.layer.shadowColor = Constants.setupInfoView.infoLargeViewShadowColor
        infoConditionsView.layer.shadowOpacity = Constants.setupInfoView.infoLargeViewShadowOpacity
        infoConditionsView.layer.shadowOffset = CGSize(width: Constants.setupInfoView.infoLargeViewShadowOffsetWidth, height: Constants.setupInfoView.infoLargeViewShadowOffsetHeight)
        infoConditionsView.layer.shadowRadius = Constants.setupInfoView.infoLargeViewShadowRadius
        return infoConditionsView
    }()
    
    private let infoConditionsViewDepth: UIView = {
        let infoConditionsViewDepth = UIView()
        infoConditionsViewDepth.backgroundColor = Constants.setupInfoView.infoLargeViewDepthBackgroundColor
        infoConditionsViewDepth.layer.cornerRadius = Constants.setupInfoView.infoLargeViewDepthCornerRadius
        infoConditionsViewDepth.layer.shadowColor = Constants.setupInfoView.infoLargeViewDepthShadowColor
        infoConditionsViewDepth.layer.shadowOpacity = Constants.setupInfoView.infoLargeViewDepthShadowOpacity
        infoConditionsViewDepth.layer.shadowOffset = Constants.setupInfoView.infoLargeViewDepthShadowOffset
        infoConditionsViewDepth.layer.shadowRadius = Constants.setupInfoView.infoLargeViewDepthShadowRadius
        return infoConditionsViewDepth
    }()
    
    private let infoConditionsViewTitleLabel: UILabel = {
        var infoLargeViewTitleLabel = UILabel()
        infoLargeViewTitleLabel.text = Constants.setupInfoView.infoLargeViewTitleLabelText
        infoLargeViewTitleLabel.font = UIFont.boldSystemFont(ofSize: infoLargeViewTitleLabel.font.pointSize)
        infoLargeViewTitleLabel.textAlignment = .center
        return infoLargeViewTitleLabel
    }()
    
    private let infoConditionsViewMainLabel: UILabel = {
        let infoConditionsViewMainLabel = UILabel()
        infoConditionsViewMainLabel.numberOfLines = 0
        infoConditionsViewMainLabel.textAlignment = .left
        infoConditionsViewMainLabel.sizeToFit()
        return infoConditionsViewMainLabel
    }()
    
    private let infoLargeViewHideButton: UIButton = {
        let infoLargeViewHideButton = UIButton()
        infoLargeViewHideButton.isEnabled = true
        infoLargeViewHideButton.setTitle(Constants.setupInfoView.infoLargeViewHideButtonTitle, for: .normal)
        infoLargeViewHideButton.setTitleColor(Constants.setupInfoView.infoLargeViewHideButtonTitleColor, for: .normal)
        infoLargeViewHideButton.layer.borderColor = Constants.setupInfoView.infoLargeViewHideButtonBorderColor
        infoLargeViewHideButton.layer.borderWidth = Constants.setupInfoView.infoLargeViewHideButtonBorderWidth
        infoLargeViewHideButton.layer.cornerRadius = Constants.setupInfoView.infoLargeViewHideButtonCornerRaidus
        return infoLargeViewHideButton
    }()
    
    init() {
        super.init(frame: CGRect(x: 0, y: screenHeight, width: screenWidth, height: screenHeight))
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
     func setupUI() {

        addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(0)
            make.trailing.leading.equalToSuperview().inset(0)
            make.height.equalTo(screenHeight)
        }
        
        addSubview(infoConditionsView)  //  основной вью для отображения текста
        infoConditionsView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Constants.Constraints.infoLargeViewTop)
            make.leading.trailing.equalToSuperview().inset(Constants.Constraints.infoLargeViewLeadingTrailing)
            make.height.equalTo(Constants.Constraints.infoLargeViewHeight)
        }
        addSubview(infoConditionsViewTitleLabel)   /// лейбла для INFO
        infoConditionsViewTitleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.infoConditionsView)
            make.leading.trailing.equalTo(infoConditionsView).inset(Constants.Constraints.infoLargeViewTitleLabelLeadingTrailing)
            make.top.equalTo(infoConditionsView.snp.top).inset(Constants.Constraints.infoLargeViewTitleLabelTop)
        }
        infoConditionsView.addSubview(infoConditionsViewMainLabel)  // лейбл для текста
        infoConditionsViewMainLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.infoConditionsView)
            make.leading.trailing.equalTo(infoConditionsView).inset(Constants.Constraints.infoLargeViewLabelLeadingTrailing)
            make.top.equalTo(infoConditionsViewTitleLabel.snp.bottom).inset(Constants.Constraints.infoLargeViewLabelTop)
            make.height.equalTo(Constants.Constraints.infoLargeViewLabelHeight)
        }
        
        infoConditionsView.addSubview(infoLargeViewHideButton)
        infoLargeViewHideButton.snp.makeConstraints { make in
            make.centerX.equalTo(self.infoConditionsView)
            make.leading.trailing.equalTo(infoConditionsView).inset(Constants.Constraints.infoLargeViewHideButtonLeadingTrailing)
            make.top.equalTo(infoConditionsViewMainLabel.snp.bottom).offset(Constants.Constraints.infoLargeViewHideButtonTop)
        }
        
    addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
//            make.top.equalTo(initialY)
            make.trailing.leading.equalToSuperview().inset(0)
            make.height.equalTo(screenHeight)
        }
    }
    
//    func infoViewHide() {
//
//    }
    
    @objc private func hideInfo() {
        self.delegate?.hideInfo()
    }
}

extension DescriptionView {
    enum Constants {
        enum Constraints {

            static let infoLargeViewTop = 100
            static let infoLargeViewLeadingTrailing = 60
            static let infoLargeViewHeight = 400
            
            static let infoLargeViewLabelLeadingTrailing = 30
            static let infoLargeViewLabelTop = 10
            static let infoLargeViewLabelHeight = 300
//
            static let infoLargeViewTitleLabelLeadingTrailing = 30
            static let infoLargeViewTitleLabelTop = 30
            
            static let infoLargeViewHideButtonLeadingTrailing = 30
                        static let infoLargeViewHideButtonTop = 5
        }
        enum Images {
            static let backgroundView = UIImageView(image: UIImage(named: "image_background.png"))
        }

        enum setupInfoView {
//            static let backgroundView = UIImageView(image: UIImage(named: "image_background.png"))
            static let infoLargeViewBackgroundColor = UIColor(red: 255/255, green: 153/255, blue: 96/255, alpha: 1)
            static let infoLargeViewCornerRadius: CGFloat = 25
            static let infoLargeViewShadowColor = UIColor.black.cgColor
            static let infoLargeViewShadowOpacity: Float = 0.2
            static let infoLargeViewShadowOffsetWidth = 0
            static let infoLargeViewShadowOffsetHeight = 10
            static let infoLargeViewShadowRadius: CGFloat = 10
//
            static let infoLargeViewDepthBackgroundColor = UIColor (red: 251/255, green: 95/255, blue: 41/255, alpha: 1)
            static let infoLargeViewDepthCornerRadius: CGFloat = 25
            static let infoLargeViewDepthShadowColor = UIColor.black.cgColor
            static let infoLargeViewDepthShadowOpacity: Float = 0.2
            static let infoLargeViewDepthShadowOffset = CGSize(width: 0, height: 10)
            static let infoLargeViewDepthShadowRadius:CGFloat = 10
//
            static let infoLargeViewTitleLabelText = "INFO"
            static let infoLargeViewLabelAttributedString = NSMutableAttributedString(string: "Brick is wet - raining \nBrick is dry - sunny \nBrick is hard to see - fog \nBrick with cracks - very hot \nBrick with snow - snow \nBrick is swinging - windy \nBrick is gone - No Internet")
            static let infoLargeViewLabelNumberOfLines = 7
            static let infoLargeViewLabelLineSPacing: CGFloat = 10
            static let infoLargeViewHideButtonTitle = "Hide"
            static let infoLargeViewHideButtonTitleColor = UIColor(red: 87/255, green: 87/255, blue: 87/255, alpha: 1)
            static let infoLargeViewHideButtonBorderColor = UIColor(red: 87/255, green: 87/255, blue: 87/255, alpha: 1).cgColor
            static let infoLargeViewHideButtonBorderWidth:CGFloat = 1.5
            static let infoLargeViewHideButtonCornerRaidus:CGFloat = 15
        }
    }
}




