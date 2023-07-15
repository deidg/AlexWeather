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
        
        clipsToBounds = true
        layer.cornerRadius = 15

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

