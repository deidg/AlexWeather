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

class SearchViewController: UIViewController {
    
    private let backgroundView = UIImageView(image: UIImage(named: "image_background"))
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
//    private func setupDelegates() {
//        self.collectionView.delegate = self
//    }

    
    
}
