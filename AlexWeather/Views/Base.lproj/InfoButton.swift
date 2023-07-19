//
//  infoButton.swift
//  AlexWeather
//
//  Created by Alex on 07.07.2023.
//

import UIKit

class InfoButton: UIButton {
    private var topColor = Constants.topColor
    private var bottomColor = Constants.bottomColor
    private let infoButtonGradientLayer: CAGradientLayer = {
        let infoButtonGradientLayer = CAGradientLayer()
//        infoButtonGradientLayer.frame = bounds
        return infoButtonGradientLayer
    }()
 
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupUI()
        setupLayers()
    }
    override func layoutSubviews() {
            super.layoutSubviews()
            infoButtonGradientLayer.frame = bounds //не убирать! или вкл 42. Кнопка жёлтая
        }
    required init?(coder: NSCoder) {
        return nil
    }
    
    func setupUI() {
        setTitle("INFO", for: .normal)
        setTitleColor(.black, for: .normal)
        contentVerticalAlignment = .top
        clipsToBounds = true
        layer.cornerRadius = Constants.cornerRadius
    }
    
    func setupLayers() {
        infoButtonGradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        infoButtonGradientLayer.locations = [0,1]
        self.layer.addSublayer(infoButtonGradientLayer)
        infoButtonGradientLayer.frame = self.bounds
//        infoButtonGradientLayer.frame = bounds
    }
}

extension InfoButton {
    enum Constants {
        static let topColor = UIColor(red: 255/255, green: 153/255, blue: 96/255, alpha: 1)
        static let bottomColor = UIColor(red: 249/255, green: 80/255, blue: 27/255, alpha: 1)
        static let cornerRadius: CGFloat = 15.0
    }
}

