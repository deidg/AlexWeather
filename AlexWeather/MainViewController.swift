//
//  ViewController.swift
//  AlexWeather
//
//  Created by Alex on 16.05.2023.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    let gradientLayer = CAGradientLayer()
    var topColor = UIColor.orange
    var bottomColor = UIColor.yellow
    let temperatureLabel: UILabel = {
        let temperatureLabel = UILabel()
        temperatureLabel.backgroundColor = .red
        return temperatureLabel
    }()
    let conditionsLabel: UILabel = {
        let conditionsLabel = UILabel()
        conditionsLabel.backgroundColor = .green
        return conditionsLabel
    }()
    let locationLabel: UILabel = {
        let locationLabel = UILabel()
        locationLabel.backgroundColor = .white
        return locationLabel
    }()
    
    
    let theStoneImageView = UIImageView(image: UIImage(named: "image_stone_cracks.png"))
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureGradientLayer()
        setupUI()
    }
    
    func configureGradientLayer() {
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0,1]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.bounds
    }
    
    func setupUI() {
        view.addSubview(theStoneImageView)
        theStoneImageView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.centerX.equalTo(self.view)
        }
        view.addSubview(temperatureLabel)
        temperatureLabel.snp.makeConstraints{ make in
            make.top.equalTo(theStoneImageView.snp.bottom).inset(10)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(270)
            make.height.equalTo(100)
        }
        view.addSubview(conditionsLabel)
        conditionsLabel.snp.makeConstraints{ make in
            make.top.equalTo(temperatureLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(250)
            make.height.equalTo(50)
        }
        view.addSubview(locationLabel)
        locationLabel.snp.makeConstraints{ make in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(view.snp.bottom).inset(50)
            make.leading.trailing.equalToSuperview().inset(100)
            make.height.equalTo(50)
        }
    }
}



//extension


//    theStoneImage.image = theStone

