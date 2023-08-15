//
//  infoButton.swift
//  AlexWeather
//
//  Created by Alex on 07.07.2023.
//
// TODO: в методое defaultConfiguration проверить посмотеть layer - он нужен для тени?


import UIKit
import SnapKit

final class InfoButton: UIButton {
    //MARK: - elements
    private let infoButtonGradientLayer: CAGradientLayer = {
        let infoButtonGradientLayer = CAGradientLayer()
        infoButtonGradientLayer.colors = [Constants.topColor.cgColor, Constants.bottomColor.cgColor]
        infoButtonGradientLayer.locations = [0.0, 1.0]
        infoButtonGradientLayer.startPoint = Constants.startPointCGPoint
        infoButtonGradientLayer.endPoint = Constants.endPointCGPoint
        infoButtonGradientLayer.cornerRadius = Constants.cornerRadius
        return infoButtonGradientLayer
    }()
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 175, height: 85))
        defaultConfiguration()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    //MARK: - methods
    func defaultConfiguration() {
        
        setTitle("INFO", for: .normal)
        setTitleColor(.black, for: .normal)
        infoButtonGradientLayer.frame = self.frame
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 47, right: 0)
        layer.insertSublayer(infoButtonGradientLayer, at: 0)
        
//        setTitle("INFO", for: .normal)
//        setTitleColor(.black, for: .normal)
//        contentVerticalAlignment = .top
//        clipsToBounds = true
//        layer.cornerRadius = Constants.cornerRadius
    }
    
//    func setupLayers() {
//        let topColor = Constants.topColor
//        let bottomColor = Constants.bottomColor
//        infoButtonGradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
//        infoButtonGradientLayer.locations = [0,1]
//        self.layer.addSublayer(infoButtonGradientLayer)
//    }
}
//MARK: - extension
extension InfoButton {
    enum Constants {
        static let topColor = UIColor(red: 255/255, green: 153/255, blue: 96/255, alpha: 1)
        static let bottomColor = UIColor(red: 249/255, green: 80/255, blue: 27/255, alpha: 1)
        static let startPointCGPoint = CGPoint(x: 0.5, y: 0.25)
        static let endPointCGPoint = CGPoint(x: 0.5, y: 0.75)
        static let cornerRadius: CGFloat = 15.0
    }
}

