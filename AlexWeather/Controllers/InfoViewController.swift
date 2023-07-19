//
//  InfoViewController.swift
//  AlexWeather
//
//  Created by Alex on 14.07.2023.
//

import Foundation
import UIKit

class InfoViewController: UIViewController { // INFO view
    //MARK: elements
    private let backgroundView: UIImageView = {
        let backgroundView = Constants.setupInfoLargeView.backgroundView
        backgroundView.contentMode = .scaleAspectFill
        return backgroundView
    }()
    private let infoLargeView: UIView = {
        let infoLargeView = UIView()
        infoLargeView.backgroundColor = Constants.setupInfoLargeView.infoLargeViewBackgroundColor
        infoLargeView.layer.cornerRadius = Constants.setupInfoLargeView.infoLargeViewCornerRadius
        infoLargeView.layer.shadowColor = Constants.setupInfoLargeView.infoLargeViewShadowColor
        infoLargeView.layer.shadowOpacity = Constants.setupInfoLargeView.infoLargeViewShadowOpacity
        infoLargeView.layer.shadowOffset = CGSize(width: Constants.setupInfoLargeView.infoLargeViewShadowOffsetWidth, height: Constants.setupInfoLargeView.infoLargeViewShadowOffsetHeight)
        infoLargeView.layer.shadowRadius = Constants.setupInfoLargeView.infoLargeViewShadowRadius
        return infoLargeView
    }()
    private let infoLargeViewDepth: UIView = {
        let infoLargeViewDepth = UIView()
        infoLargeViewDepth.backgroundColor = Constants.setupInfoLargeView.infoLargeViewDepthBackgroundColor
        infoLargeViewDepth.layer.cornerRadius = Constants.setupInfoLargeView.infoLargeViewDepthCornerRadius
        infoLargeViewDepth.layer.shadowColor = Constants.setupInfoLargeView.infoLargeViewDepthShadowColor
        infoLargeViewDepth.layer.shadowOpacity = Constants.setupInfoLargeView.infoLargeViewDepthShadowOpacity
        infoLargeViewDepth.layer.shadowOffset = Constants.setupInfoLargeView.infoLargeViewDepthShadowOffset
        infoLargeViewDepth.layer.shadowRadius = Constants.setupInfoLargeView.infoLargeViewDepthShadowRadius
        return infoLargeViewDepth
    }()
    private let infoLargeViewTitleLabel: UILabel = {
        var infoLargeViewTitleLabel = UILabel()
        infoLargeViewTitleLabel.text = Constants.setupInfoLargeView.infoLargeViewTitleLabelText
        infoLargeViewTitleLabel.font = UIFont.boldSystemFont(ofSize: infoLargeViewTitleLabel.font.pointSize)
        infoLargeViewTitleLabel.textAlignment = .center
        return infoLargeViewTitleLabel
    }()
    private let infoLargeViewLabel: UILabel = {
        let infoLargeViewLabel = UILabel()
        infoLargeViewLabel.numberOfLines = 0
        infoLargeViewLabel.textAlignment = .left
        return infoLargeViewLabel
    }()
    let infoButtonShadow = Constants.setupInfoLargeView.infoButtonShadowFrame
    
    private let infoButtonShadowView: UIView = {
        let infoButtonShadow = UIView()
        infoButtonShadow.backgroundColor = UIColor.yellow
        infoButtonShadow.layer.shadowColor = UIColor.black.cgColor
        infoButtonShadow.layer.shadowOpacity = Constants.setupInfoLargeView.infoButtonShadowShadowOpacity
        infoButtonShadow.layer.shadowOffset = Constants.setupInfoLargeView.infoButtonShadowShadowOffset
        infoButtonShadow.layer.shadowRadius = Constants.setupInfoLargeView.infoButtonShadowShadowRadius
        infoButtonShadow.layer.cornerRadius = Constants.setupInfoLargeView.infoButtonShadowCornerRadius
        return infoButtonShadow
    }()
    private let infoLargeViewHideButton: UIButton = {
        let infoLargeViewHideButton = UIButton()
        infoLargeViewHideButton.isEnabled = true
        infoLargeViewHideButton.setTitle(Constants.setupInfoLargeView.infoLargeViewHideButtonTitle, for: .normal)
        infoLargeViewHideButton.setTitleColor(Constants.setupInfoLargeView.infoLargeViewHideButtonTitleColor, for: .normal)
        infoLargeViewHideButton.layer.borderColor = Constants.setupInfoLargeView.infoLargeViewHideButtonBorderColor
        infoLargeViewHideButton.layer.borderWidth = Constants.setupInfoLargeView.infoLargeViewHideButtonBorderWidth
        infoLargeViewHideButton.layer.cornerRadius = Constants.setupInfoLargeView.infoLargeViewHideButtonCornerRaidus
        return infoLargeViewHideButton
    }()
    //MARK: VIewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addTargets()
        setupInfoLargeView()
    }
    //MARK: Methods
    func setupUI() {
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        view.addSubview(infoButtonShadowView)
        view.addSubview(infoLargeViewDepth)    // глубинf
        infoLargeViewDepth.snp.makeConstraints{ make in
            make.top.equalTo(view).inset(Constants.Constraints.infoLargeViewDepthTop)
            make.leading.equalTo(view).inset(Constants.Constraints.infoLargeViewDepthLeading)
            make.trailing.equalTo(view).inset(Constants.Constraints.infoLargeViewDepthTrailing)
            make.height.equalTo(400)
        }
        infoLargeViewDepth.addSubview(infoLargeView)  // основной оранжевый
        infoLargeView.snp.makeConstraints{ make in
            make.centerX.equalTo(self.view)
            make.top.equalTo(view).inset(100)
            make.leading.trailing.equalTo(view).inset(60)
            make.height.equalTo(400)
        }
        view.addSubview(infoLargeViewTitleLabel)    // INFO
        infoLargeViewTitleLabel.snp.makeConstraints{ make in
            make.centerX.equalTo(self.infoLargeView)
            make.leading.trailing.equalTo(infoLargeView).inset(Constants.Constraints.infoLargeViewTitleLabelLeadingTrailing)
            make.top.equalTo(infoLargeView.snp.top).inset(Constants.Constraints.infoLargeViewTitleLabelTop)
        }
        view.addSubview(infoLargeViewLabel)   // сам текст
        infoLargeViewLabel.snp.makeConstraints{ make in
            make.centerX.equalTo(self.infoLargeView)
            make.leading.trailing.equalTo(infoLargeView).inset(Constants.Constraints.infoLargeViewLabelLeadingTrailing)
            make.top.equalTo(infoLargeViewTitleLabel.snp.top).inset(Constants.Constraints.infoLargeViewLabelTop)
            make.height.equalTo(300)
 }
        view.addSubview(infoLargeViewHideButton)
        infoLargeViewHideButton.snp.makeConstraints{ make in
            make.centerX.equalTo(self.infoLargeView)
            make.leading.trailing.equalTo(infoLargeView).inset(Constants.Constraints.infoLargeViewHideButtonLeadingTrailing)
            make.top.equalTo(infoLargeViewLabel.snp.bottom).offset(Constants.Constraints.infoLargeViewHideButtonTop)
        }
    }
    private func addTargets() {
        infoLargeViewHideButton.addTarget(self, action: #selector(hideButtonPressed), for: .touchUpInside)
    }
    private func setupInfoLargeView() {
        let attributedString = Constants.setupInfoLargeView.infoLargeViewLabelAttributedString
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = Constants.setupInfoLargeView.infoLargeViewLabelLineSPacing
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        infoLargeViewLabel.attributedText = attributedString
    }
    @objc private func hideButtonPressed(sender: UIButton) {
        dismiss(animated: true)
    }
}
// MARK: Extension
extension InfoViewController {
    enum Constants {
        enum Constraints {
            static let infoLargeViewDepthTop = 100
            static let infoLargeViewDepthLeading = 80
            static let infoLargeViewDepthTrailing = 40
            
            static let infoLargeViewTitleLabelLeadingTrailing = 30
            static let infoLargeViewTitleLabelTop = 30
            
            static let infoLargeViewLabelLeadingTrailing = 30
            static let infoLargeViewLabelTop = 10
            

            static let infoLargeViewHideButtonLeadingTrailing = 30
            static let infoLargeViewHideButtonTop = 5
        }
        enum setupInfoLargeView {
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
