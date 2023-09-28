//
//  StoneView.swift
//  AlexWeather
//
//  Created by Alex on 27.07.2023.
//

import UIKit
import CoreLocation
import Foundation

final class StoneImageView: UIImageView {
    // MARK: Elements
    var stoneState: StoneState = .normal(windy: false) {
        didSet {
            applyState(state: stoneState)
        }
    }
    private let pendulumAnimation: CAKeyframeAnimation = {
        let animation = CAKeyframeAnimation(keyPath: Constants.keyPathName)
        animation.duration = 4.0
        animation.fillMode = .both
        animation.repeatCount = Float.infinity
        animation.values = [0, Double.pi/50, 0, -(Double.pi/50), 0]
        animation.keyTimes = [NSNumber(value: 0.0),
                              NSNumber(value: 0.3),
                              NSNumber(value: 0.5),
                              NSNumber(value: 0.8),
                              NSNumber(value: 1.0)
        ]
        return animation
    }()
    // MARK: Inits
    init() {
        super.init(frame: .zero)
        applyState(state: .normal(windy: false))
        
    }
    required init?(coder: NSCoder) {
        return nil
    }
    // MARK: Methods
    private func applyState(state: StoneState) {
        let image: UIImage?
        let alpha: CGFloat
        self.layer.removeAllAnimations()
        
        switch state {
        case .normal:
            image = UIImage(named: Constants.stoneImageNameNormal)
            alpha = 1
        case .rain:
            image = UIImage(named: Constants.stoneImageNameWet)
            alpha = 1
        case .snow:
            image = UIImage(named: Constants.stoneImageNameSnow)
            alpha = 1
        case .fog:
            image = UIImage(named: Constants.stoneImageNameNormal)
            alpha = 0.3
        case .hot:
            image = UIImage(named: Constants.stoneImageNameCracks)
            alpha = 1
        case .noInternet:
            image = UIImage(named: Constants.stoneImageNameNormal)
            alpha = 0
        }
        
        self.image = image
        self.alpha = alpha
        if state.isWindy {
            layer.add(pendulumAnimation, forKey: Constants.forKeyName)
        }
    }
}
// MARK: Extension
extension StoneImageView {
    enum StoneState {
        case normal(windy: Bool)
        case rain(windy: Bool)
        case snow(windy: Bool)
        case fog(windy: Bool)
        case hot(windy: Bool)
        case noInternet
        
        var isWindy: Bool {
            switch self {
            case .noInternet:
                return false
            case .normal(let windy):
                return windy
            case .rain(let windy):
                return windy
            case .snow(let windy):
                return windy
            case .fog(let windy):
                return windy
            case .hot(let windy):
                return windy
            }
        }
        
        init(temperature: Int, conditionCode: Int, windSpeed: Double) {
            if temperature > 30 {
                self = .hot(windy: windSpeed > 1)
            } else if temperature < 30 && conditionCode >= 100 && conditionCode <= 531 {
                self = .rain(windy: windSpeed > 1)
            } else if temperature < 30 && conditionCode >= 600 && conditionCode <= 622 {
                self = .snow(windy: windSpeed > 1)
            } else if temperature < 30 && conditionCode >= 701 && conditionCode <= 781 {
                self = .fog(windy: windSpeed > 1)
            } else if temperature < 30 && conditionCode > 800 {
                self = .normal(windy: windSpeed > 1)
            } else {
                self = .normal(windy: false)
            }
        }
    }
}
// MARK: Extension
extension StoneImageView {
    enum Constants {
        static let stoneImageNameNormal = "image_stone_normal"
        static let stoneImageNameWet = "image_stone_wet"
        static let stoneImageNameSnow = "image_stone_snow"
        static let stoneImageNameCracks = "image_stone_cracks"
        static let keyPathName = "transform.rotation"
        static let forKeyName = "rotationAnimation"
    }
}
