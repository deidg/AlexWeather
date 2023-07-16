//
//  InfoViewController.swift
//  AlexWeather
//
//  Created by Alex on 14.07.2023.
//

import Foundation
import UIKit

class InfoViewController: UIViewController {
    
//    let mainViewController = MainViewController()
    
    private let backgroundView: UIImageView = {
        let backgroundView = UIImageView(image: UIImage(named: "image_background.png"))
        backgroundView.contentMode = .scaleAspectFill
        return backgroundView
    }()
    //    private let scrollView: UIScrollView = {
    //        var view = UIScrollView()
    //        view.isScrollEnabled = true
    //        view.alwaysBounceVertical = true
    //        return view
    //    }()
    //    private let contentView: UIView = {
    //        let view = UIView()
    //        return view
    //    }()
    private let infoLargeView: UIView = { // INFO view
        let infoLargeView = UIView()
        return infoLargeView
    }()
    private let infoLargeViewDepth: UIView = {
        let infoLargeViewDepth = UIView()
        return infoLargeViewDepth
    }()
    private let infoLargeViewTitleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    private let infoLargeViewLabel: UILabel = {   //INFO view (label text)
        let label = UILabel()
        return label
    }()
    private let infoButtonShadowView: UIView = {
        let infoButtonShadow = UIView()
        return infoButtonShadow
    }()
    private let infoLargeViewHideButton: UIButton = {  //INFO view
        let infoLargeViewHideButton = UIButton()
        return infoLargeViewHideButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addTargets()
        setupInfoLargeView()
    }
    
    
    func setupUI() {
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        //        view.addSubview(scrollView)
        //        scrollView.snp.makeConstraints { make in
        //            make.edges.equalToSuperview()
        //        }
        //        scrollView.addSubview(contentView)
        //        contentView.snp.makeConstraints { make in
        //            make.centerX.equalTo(scrollView)
        //            make.top.bottom.equalTo(scrollView).offset(-60)
        //        }
        
        view.addSubview(infoButtonShadowView)
        
        view.addSubview(infoLargeViewDepth)
        infoLargeViewDepth.snp.makeConstraints{ make in
            make.top.bottom.equalTo(view).inset(Constants.Constraints.infoLargeViewDepthTop)
            make.leading.equalTo(view).inset(Constants.Constraints.infoLargeViewDepthLeading)
            make.trailing.equalTo(view).inset(Constants.Constraints.infoLargeViewDepthTrailing)
        }
        infoLargeViewDepth.addSubview(infoLargeView)
        infoLargeView.snp.makeConstraints{ make in
            make.centerX.equalTo(self.view)
            make.top.bottom.equalTo(view).inset(200)
            make.leading.trailing.equalTo(view).inset(60)
        }
        view.addSubview(infoLargeViewTitleLabel)
        infoLargeViewTitleLabel.snp.makeConstraints{ make in
            make.centerX.equalTo(self.infoLargeView)
            make.leading.trailing.equalTo(infoLargeView).inset(Constants.Constraints.infoLargeViewTitleLabelLeadingTrailing)
            make.top.equalTo(infoLargeView.snp.top).inset(Constants.Constraints.infoLargeViewTitleLabelTop)
        }
        view.addSubview(infoLargeViewLabel)
        infoLargeViewLabel.snp.makeConstraints{ make in
            make.centerX.equalTo(self.infoLargeView)
            make.leading.trailing.equalTo(infoLargeView).inset(Constants.Constraints.infoLargeViewLabelLeadingTrailing)
            make.top.equalTo(infoLargeViewTitleLabel.snp.top).inset(Constants.Constraints.infoLargeViewLabelTop)
        }
        view.addSubview(infoLargeViewHideButton)
        infoLargeViewHideButton.snp.makeConstraints{ make in
            make.centerX.equalTo(self.infoLargeView)
            make.leading.trailing.equalTo(infoLargeView).inset(Constants.Constraints.infoLargeViewHideButtonLeadingTrailing)
            make.top.equalTo(infoLargeViewLabel.snp.bottom).offset(Constants.Constraints.infoLargeViewHideButtonTop)
        }
    }
   
    private func addTargets() {  // устанавливаем селекторы на кнопки и движения
        infoLargeViewHideButton.addTarget(self, action: #selector(hideButtonPressed), for: .touchUpInside)
    }

    private func setupInfoLargeView() {
        infoLargeView.backgroundColor = Constants.setupInfoLargeView.infoLargeViewBackgroundColor
        infoLargeView.layer.cornerRadius = Constants.setupInfoLargeView.infoLargeViewCornerRadius
        infoLargeView.layer.shadowColor = Constants.setupInfoLargeView.infoLargeViewShadowColor
        infoLargeView.layer.shadowOpacity = Constants.setupInfoLargeView.infoLargeViewShadowOpacity //0.5
        infoLargeView.layer.shadowOffset = CGSize(width: Constants.setupInfoLargeView.infoLargeViewShadowOffsetWidth, height: Constants.setupInfoLargeView.infoLargeViewShadowOffsetHeight)
        infoLargeView.layer.shadowRadius = Constants.setupInfoLargeView.infoLargeViewShadowRadius
        
        infoLargeViewDepth.backgroundColor = Constants.setupInfoLargeView.infoLargeViewDepthBackgroundColor
        infoLargeViewDepth.layer.cornerRadius = Constants.setupInfoLargeView.infoLargeViewDepthCornerRadius
        infoLargeViewDepth.layer.shadowColor = Constants.setupInfoLargeView.infoLargeViewDepthShadowColor
        infoLargeViewDepth.layer.shadowOpacity = Constants.setupInfoLargeView.infoLargeViewDepthShadowOpacity //0.5
        infoLargeViewDepth.layer.shadowOffset = Constants.setupInfoLargeView.infoLargeViewDepthShadowOffset
        infoLargeViewDepth.layer.shadowRadius = Constants.setupInfoLargeView.infoLargeViewDepthShadowRadius
        
        infoLargeViewTitleLabel.text = Constants.setupInfoLargeView.infoLargeViewTitleLabelText
        infoLargeViewTitleLabel.font = UIFont.boldSystemFont(ofSize: infoLargeViewTitleLabel.font.pointSize)
        infoLargeViewTitleLabel.textAlignment = .center
        infoLargeViewLabel.numberOfLines = Constants.setupInfoLargeView.infoLargeViewLabelNumberOfLines
        infoLargeViewLabel.textAlignment = .left
        let attributedString = Constants.setupInfoLargeView.infoLargeViewLabelAttributedString
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = Constants.setupInfoLargeView.infoLargeViewLabelLineSPacing
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        infoLargeViewLabel.attributedText = attributedString
        let infoButtonShadow = Constants.setupInfoLargeView.infoButtonShadowFrame
        infoButtonShadow.backgroundColor = UIColor.yellow
        infoButtonShadow.layer.shadowColor = UIColor.black.cgColor
        infoButtonShadow.layer.shadowOpacity = Constants.setupInfoLargeView.infoButtonShadowShadowOpacity
        infoButtonShadow.layer.shadowOffset = Constants.setupInfoLargeView.infoButtonShadowShadowOffset
        infoButtonShadow.layer.shadowRadius = Constants.setupInfoLargeView.infoButtonShadowShadowRadius
        infoButtonShadow.layer.cornerRadius = Constants.setupInfoLargeView.infoButtonShadowCornerRadius
        infoLargeViewHideButton.isEnabled = true
        infoLargeViewHideButton.setTitle(Constants.setupInfoLargeView.infoLargeViewHideButtonTitle, for: .normal)
        infoLargeViewHideButton.setTitleColor(Constants.setupInfoLargeView.infoLargeViewHideButtonTitleColor, for: .normal)
        infoLargeViewHideButton.layer.borderColor = Constants.setupInfoLargeView.infoLargeViewHideButtonBorderColor
        infoLargeViewHideButton.layer.borderWidth = Constants.setupInfoLargeView.infoLargeViewHideButtonBorderWidth
        infoLargeViewHideButton.layer.cornerRadius = Constants.setupInfoLargeView.infoLargeViewHideButtonCornerRaidus
    }
    
    @objc private func hideButtonPressed(sender: UIButton) {
        print("closed!")
        dismiss(animated: false)
    }
}

extension InfoViewController {
    enum Constants {
        enum Constraints {
            static let infoLargeViewDepthTop = 200
            static let infoLargeViewDepthLeading = 80
            static let infoLargeViewDepthTrailing = 40
            
            static let infoLargeViewTitleLabelLeadingTrailing = 30
            static let infoLargeViewTitleLabelTop = 30
            
            static let infoLargeViewLabelLeadingTrailing = 30
            static let infoLargeViewLabelTop = 50
            
            static let infoLargeViewHideButtonLeadingTrailing = 30
            static let infoLargeViewHideButtonTop = 20
        }
        enum setupInfoLargeView {
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
            static let infoLargeViewLabelAttributedString  = NSMutableAttributedString(string: "Brick is wet - raining \nBrick is dry - sunny \nBrick is hard to see - fog \nBrick with cracks - very hot \nBrick with snow - snow \nBrick is swinging - windy \nBrick is gone - No Internet")
            static let infoLargeViewLabelNumberOfLines = 7
            static let infoLargeViewLabelLineSPacing: CGFloat = 20

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
