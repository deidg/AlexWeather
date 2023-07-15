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
            make.top.bottom.equalTo(view).inset(200)
            make.leading.equalTo(view).inset(80)
            make.trailing.equalTo(view).inset(40)
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
            make.leading.trailing.equalTo(infoLargeView).inset(30)
            make.top.equalTo(infoLargeView.snp.top).inset(30)
        }
        view.addSubview(infoLargeViewLabel)
        infoLargeViewLabel.snp.makeConstraints{ make in
            make.centerX.equalTo(self.infoLargeView)
            make.leading.trailing.equalTo(infoLargeView).inset(30)
            make.top.equalTo(infoLargeViewTitleLabel.snp.top).inset(50)
        }
        view.addSubview(infoLargeViewHideButton)
        infoLargeViewHideButton.snp.makeConstraints{ make in
            make.centerX.equalTo(self.infoLargeView)
            make.leading.trailing.equalTo(infoLargeView).inset(30)
            make.top.equalTo(infoLargeViewLabel.snp.bottom).offset(20)
        }
    }
    
    
    private func addTargets() {  // устанавливаем селекторы на кнопки и движения
        infoLargeViewHideButton.addTarget(self, action: #selector(hideButtonPressed), for: .touchUpInside)
    }
    
    
    
    private func setupInfoLargeView() {
        infoLargeView.backgroundColor = UIColor(red: 255/255, green: 153/255, blue: 96/255, alpha: 1)
        infoLargeView.layer.cornerRadius = 25
        infoLargeView.layer.shadowColor = UIColor.black.cgColor
        infoLargeView.layer.shadowOpacity = 0.2 //0.5
        infoLargeView.layer.shadowOffset = CGSize(width: 0, height: 10)
        infoLargeView.layer.shadowRadius = 10
        infoLargeViewDepth.backgroundColor = UIColor(red: 251/255, green: 95/255, blue: 41/255, alpha: 1)
        infoLargeViewDepth.layer.cornerRadius = 25
        infoLargeViewDepth.layer.shadowColor = UIColor.black.cgColor
        infoLargeViewDepth.layer.shadowOpacity = 0.2 //0.5
        infoLargeViewDepth.layer.shadowOffset = CGSize(width: 0, height: 10)
        infoLargeViewDepth.layer.shadowRadius = 10
        infoLargeViewTitleLabel.text = "INFO"
        infoLargeViewTitleLabel.font = UIFont.boldSystemFont(ofSize: infoLargeViewTitleLabel.font.pointSize)
        infoLargeViewTitleLabel.textAlignment = .center
        infoLargeViewLabel.numberOfLines = 7
        infoLargeViewLabel.textAlignment = .left
        let attributedString = NSMutableAttributedString(string: "Brick is wet - raining \nBrick is dry - sunny \nBrick is hard to see - fog \nBrick with cracks - very hot \nBrick with snow - snow \nBrick is swinging - windy \nBrick is gone - No Internet")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 20
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        infoLargeViewLabel.attributedText = attributedString
        let infoButtonShadow = UIView(frame: CGRect(x: 110, y: 800, width: 175, height: 85))
        infoButtonShadow.backgroundColor = UIColor.yellow
        infoButtonShadow.layer.shadowColor = UIColor.black.cgColor
        infoButtonShadow.layer.shadowOpacity = 0.2
        infoButtonShadow.layer.shadowOffset = CGSize(width: 10, height: 5)
        infoButtonShadow.layer.shadowRadius = 5
        infoButtonShadow.layer.cornerRadius = 15
        infoLargeViewHideButton.isEnabled = true
        infoLargeViewHideButton.setTitle("Hide", for: .normal)
        infoLargeViewHideButton.setTitleColor(UIColor(red: 87/255, green: 87/255, blue: 87/255, alpha: 1), for:  .normal)
        infoLargeViewHideButton.layer.borderColor = UIColor(red: 87/255, green: 87/255, blue: 87/255, alpha: 1).cgColor
        infoLargeViewHideButton.layer.borderWidth = 1.5
        infoLargeViewHideButton.layer.cornerRadius = 15
    }
    
    @objc private func hideButtonPressed(sender: UIButton) {    // закрытие INFO
        print("closed!")
        dismiss(animated: false)
    }
}
