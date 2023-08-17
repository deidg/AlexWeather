//
//  InfoView.swift
//  AlexWeather
//
//  Created by Alex on 27.07.2023.
//



import UIKit
import SnapKit

// MARK: Protocol
protocol DescriptionViewDelegate: AnyObject {
    func hideInfo()
}

class DescriptionView: UIView {
    // MARK: Elements
    weak var delegate: DescriptionViewDelegate?

    private let infoView: UIView = {
        let infoView = UIView()
        infoView.backgroundColor = Constants.backgroundColor
        infoView.layer.cornerRadius = Constants.cornerRadius
        return infoView
    }()
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = Constants.Title.text
        titleLabel.textColor = Constants.labelColor
        titleLabel.font = Constants.Title.font
        return titleLabel
    }()
    private let infoLabel: UILabel = {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.75  
        let infoLabel = UILabel()
        infoLabel.numberOfLines = 0
        infoLabel.attributedText = NSMutableAttributedString(
            string: Constants.InfoLabel.text,
            attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        infoLabel.textColor = Constants.labelColor
        infoLabel.font = Constants.InfoLabel.font
        return infoLabel
    }()
    private let hideButton: UIButton = {
        let hideButton =  UIButton()
        hideButton.setTitle(Constants.HideButton.titleText, for: .normal)
        hideButton.layer.cornerRadius = Constants.HideButton.cornerRadius
        hideButton.layer.borderColor = Constants.HideButton.borderColor
        hideButton.layer.borderWidth = Constants.HideButton.borderWidth
        hideButton.setTitleColor(Constants.HideButton.titleColor, for: .normal)
        hideButton.titleLabel?.font = Constants.HideButton.titleFont
        return hideButton
    }()
    // MARK: Inits
    init() {
        super.init(frame: .zero)
        defaultConfiguration()
        setupUI()
    }
    required init?(coder: NSCoder) {
        return nil
    }
    // MARK: Methods
    private func setupUI() {
        addSubview(infoView)
        infoView.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
            make.trailing.equalToSuperview().inset(Constants.Offsets.infoViewTrailing)
        }
        infoView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.Offsets.spacing)
            make.centerX.equalToSuperview()
        }
        infoView.addSubview(infoLabel)
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.Offsets.spacing)
            make.centerX.equalToSuperview()
        }
        infoView.addSubview(hideButton)
        hideButton.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(Constants.Offsets.top)
            make.bottom.equalToSuperview().inset(Constants.Offsets.spacing)
            make.centerX.equalToSuperview()
            make.height.equalTo(Constants.Offsets.hideButtonHeight)
            make.width.equalTo(Constants.Offsets.hideButtonWidth)
        }
    }
    
    private func defaultConfiguration() {
        backgroundColor = Constants.backgroundDark
        layer.cornerRadius = Constants.cornerRadius
        hideButton.addTarget(self, action: #selector(hideInfo), for: .touchUpInside)
    }
    
    @objc private func hideInfo() {
        self.delegate?.hideInfo()
    }
}
// MARK: Extension
extension DescriptionView {
    enum Constants {
        static let backgroundDark = UIColor(red: 0.984, green: 0.373, blue: 0.161, alpha: 1)
        static let backgroundColor = UIColor(red: 1, green: 0.6, blue: 0.375, alpha: 1)
        static let cornerRadius: CGFloat = 15
        static let labelColor = UIColor(red: 0.175, green: 0.175, blue: 0.175, alpha: 1)
        enum Title {
            static let text = "INFO"
            static let font = UIFont(name: "SFProDisplay-SemiBold", size: 18) ?? UIFont.systemFont(ofSize: 18)
        }
        enum InfoLabel {
            static let text = "Brick is wet - raining\nBrick is dry - sunny \nBrick is hard to see - fog\nBrick with cracks - very hot \nBrick with snow - snow\nBrick is swinging- windy\nBrick is gone - No Internet "
            static let font = UIFont(name: "SFProDisplay-Light", size: 15) ?? UIFont.systemFont(ofSize: 15)
        }
        enum HideButton {
            static let titleText = "Hide"
            static let cornerRadius: CGFloat = 15
            static let borderColor = UIColor(red: 0.342, green: 0.342, blue: 0.342, alpha: 1).cgColor
            static let borderWidth: CGFloat = 1
            static let titleColor = UIColor(red: 0.342, green: 0.342, blue: 0.342, alpha: 1)
            static let titleFont = UIFont(name: "SFProDisplay-Semibold", size: 15) ?? UIFont.systemFont(ofSize: 15)
        }
        enum Offsets {
            static let spacing: CGFloat = 24
            static let top: CGFloat = 32
            static let hideButtonHeight: CGFloat = 31
            static let hideButtonWidth: CGFloat = 115
            static let infoViewTrailing: CGFloat =  8
        }
    }
}

