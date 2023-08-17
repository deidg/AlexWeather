//
//  SearchViewController.swift
//  AlexWeather
//
//  Created by Alex on 17.08.2023.
//

import UIKit
import CoreLocation
import SnapKit
import Network

class SearchViewController {
    
    private let backgroundView = UIImageView(image: UIImage(named: "image_background"))
    
    
     func viewDidLoad() {
//        super.viewDidLoad()
        defaultConfiguration()
        setupUI()
//        addTargets()
//        startLocationManager()
    }
    
    private func setupUI() {
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func defaultConfiguration() {
        
    }

    
    
}
