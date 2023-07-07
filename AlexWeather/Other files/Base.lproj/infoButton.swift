//
//  infoButton.swift
//  AlexWeather
//
//  Created by Alex on 07.07.2023.
//

import UIKit

class InfoButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 110, y: 800, width: 175, height: 85))
        
        setTitle("INFO", for: .normal)
        setTitleColor(.black, for: .normal)
        contentVerticalAlignment = .top
        clipsToBounds = true
        layer.cornerRadius = 15.0
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

