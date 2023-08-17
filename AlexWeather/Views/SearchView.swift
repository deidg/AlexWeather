////
////  SearchView.swift
////  AlexWeather
////
////  Created by Alex on 16.08.2023.
////
//
//import UIKit
//import SnapKit
//
//final class SearchView: UIView {
//    
//    private let searchView: UIView = {
//        let searchView = UIView()
//        searchView.backgroundColor = .white
//        searchView.alpha = 0.5
//        searchView.layer.cornerRadius = 15
//        
//        return searchView
//    }()
//    private let searchTextField: UITextField = {
//        let searchTextField = UITextField()
//        searchTextField.placeholder = "enter city name"
//        searchTextField.textColor = .green
//        return searchTextField
//    }()
//    
//    
//     init() {
//         super.init(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
//         setupUI()
//    }
//    
//    required init?(coder: NSCoder) {
//        return nil
//    }
//    
//    
//    func setupUI() {
//        addSubview(searchView)
//        searchView.snp.makeConstraints { make in
//            make.centerX.centerY.equalToSuperview()
//        }
//        addSubview(searchTextField)
//        searchTextField.snp.makeConstraints { make in
//            make.size.equalTo(searchView)
//        }
//    }
//    
//}
//
//
