//
//  infoButton.swift
//  AlexWeather
//
//  Created by Alex on 07.07.2023.
//

import UIKit

class InfoButton: UIButton {
    private var topColor = UIColor.orange
    private var bottomColor = UIColor.yellow
    private let infoButtonGradientLayer = CAGradientLayer()

    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 110, y: 800, width: 175, height: 85))
        setTitle("INFO", for: .normal)
        setTitleColor(.black, for: .normal)
        contentVerticalAlignment = .top
        clipsToBounds = true  //false
        layer.cornerRadius = 15.0
        layer.shadowColor = UIColor.red.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 10, height: 5)
        layer.shadowRadius = 5
        
        infoButtonGradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        infoButtonGradientLayer.locations = [0,1]
        self.layer.addSublayer(infoButtonGradientLayer)
        infoButtonGradientLayer.frame = self.bounds
        
    }
    required init?(coder: NSCoder) {
        return nil
    }
}

