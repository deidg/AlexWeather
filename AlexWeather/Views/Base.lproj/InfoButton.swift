//
//  infoButton.swift
//  AlexWeather
//
//  Created by Alex on 07.07.2023.
//

import UIKit

class InfoButton: UIButton {
    private var topColor = UIColor(red: 255/255, green: 153/255, blue: 96/255, alpha: 1)
    private var bottomColor = UIColor(red: 249/255, green: 80/255, blue: 27/255, alpha: 1)
    private let infoButtonGradientLayer = CAGradientLayer()
 
    override init(frame: CGRect) {
        super.init(frame: .zero)
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
    
    override func layoutSubviews() {
            super.layoutSubviews()
            infoButtonGradientLayer.frame = bounds // Update the gradient layer frame
        }
    
    required init?(coder: NSCoder) {
        return nil
    }
}

