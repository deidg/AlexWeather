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
    

    let theStoneImageView = UIImageView(image: UIImage(named: "image_stone_cracks.png"))
//    theStoneImageView.sizeToFit()

//    остановился на добавлении камня на картинку.

    
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
    }
}



//extension


//    theStoneImage.image = theStone

