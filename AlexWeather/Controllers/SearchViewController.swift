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


//TODO: make adjustable number of lines for answers

class SearchViewController: UIViewController {
    // MARK: Elements
    private let backgroundView = UIImageView(image: UIImage(named: "image_background"))
    private let searchView: UIView = {
        let searchView = UIView()
        searchView.backgroundColor = .white
//        searchView.alpha = 0.5
        searchView.layer.cornerRadius = 15
        return searchView
    }()
    private let searchTextField: UITextField = {
        let searchTextField = UITextField()
        searchTextField.backgroundColor = .white
        searchTextField.alpha = 0.6
        searchTextField.layer.cornerRadius = 15
        return searchTextField
    }()
    private let preSelectionTableView: UITableView = {
        let preSelectionTableView = UITableView()
        preSelectionTableView.backgroundColor = .white
        preSelectionTableView.alpha = 0.5
        preSelectionTableView.layer.cornerRadius = 15
        return preSelectionTableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        defaultConfiguration()
        setupUI()
//        addTargets()
//        startLocationManager()
    }
    //MARK: Items On View
    private func setupUI() {
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        view.addSubview(searchView)
        searchView.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(view).inset(100)
            make.horizontalEdges.equalTo(view).inset(30)
            make.height.equalTo(50)
        }
        view.addSubview(searchTextField)
        searchTextField.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(view).inset(100)
            make.horizontalEdges.equalTo(view).inset(30)
            make.height.equalTo(50)
        }
        view.addSubview(preSelectionTableView)
        preSelectionTableView.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(view).inset(100)
            make.horizontalEdges.equalTo(view).inset(30)
            make.bottom.equalTo(view.snp.bottom).inset(50+150)
        }
    }
    //MARK: Methods
    private func defaultConfiguration() {
        
    }

    
    
}
