//
//  StoneView.swift
//  AlexWeather
//
//  Created by Alex on 27.07.2023.
//

import Foundation
import UIKit


class StoneView: UIView {
    
    private var stoneImageView = UIImageView()
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    private func setupUI() {
        addSubview(stoneImageView)
        stoneImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.trailing.leading.equalToSuperview()
            make.top.equalToSuperview().offset(Constants.Constraints.stoneImageViewTopOffset)
        }
    }
    
    func setStoneImage(_ image: UIImage?) {
        stoneImageView.image = image
    }
    
}

extension StoneView {
    enum Constants {
        enum Constraints {
            static let stoneImageViewTopOffset = -570
        }
    }
}
