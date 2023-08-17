//
//  SearchButton.swift
//  AlexWeather
//
//  Created by Alex on 16.08.2023.
//

import UIKit
import SnapKit

final class SearchButton: UIButton {
    
    
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        defaultConfiguration()
    }
    
    required init?(coder: NSCoder) {
                return nil
    }
 
    
    func defaultConfiguration() {
        setImage(UIImage(named: "icon_search"), for: UIControl.State.normal)
    }
}
