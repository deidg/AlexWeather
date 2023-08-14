//
//  StoneView.swift
//  AlexWeather
//
//  Created by Alex on 27.07.2023.
//

import UIKit

final class StoneImageView: UIImageView {
    var stoneState: StoneState = .normal(windy: false) {
        didSet {
            applyState(state: stoneState)
        }
    }
    
    
    private let pendulumAnimation: CABasicAnimation = {
       let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = 0
        animation.toValue = Double.pi / 10
        animation.duration = 2
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        return animation
    }()
    
    init() {
        super.init(frame: .zero)
        applyState(state: .normal(windy: true))
        
    }
    required init?(coder: NSCoder) {
        return nil
    }
    
    private func applyState(state: StoneState) {
        let image: UIImage?
        let alpha: CGFloat
        self.layer.removeAllAnimations()
        
        switch state {
        case .normal:
            image = UIImage(named: "image_stone_normal")
            alpha = 1
        case .rain:
            image = UIImage(named: "image_stone_wet")
            alpha = 1
        case .snow:
            image = UIImage(named: "image_stone_snow")
            alpha = 1
        case .fog:
            image = UIImage(named: "image_stone_normal")
            alpha = 0.3
        case .hot:
            image = UIImage(named: "image_stone_cracks")
            alpha = 1
        }
        self.image = image
        self.alpha = alpha
        if state.isWindy {
            layer.add(pendulumAnimation, forKey: "rotationAnimation")
        }
    }
}

extension StoneImageView {
    enum StoneState {
        case normal(windy: Bool)
        case rain(windy: Bool)
        case snow(windy: Bool)
        case fog(windy: Bool)
        case hot(windy: Bool)
        
        var isWindy: Bool {
            switch self {
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
                self = .hot(windy: windSpeed > 5)
            } else if temperature < 30 && conditionCode >= 100 && conditionCode <= 531 {
                self = .rain(windy: windSpeed > 5)
            } else if temperature < 30 && conditionCode >= 600 && conditionCode <= 622 {
                self = .snow(windy: windSpeed > 5)
            } else if temperature < 30 && conditionCode >= 701 && conditionCode <= 781 {
                self = .fog(windy: windSpeed > 5)
            } else if temperature < 30 && conditionCode > 800 {
                self = .normal(windy: windSpeed > 5)
            } else {
                self = .normal(windy: false)
            }
        }
    }
}
