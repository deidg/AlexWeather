//
//  ViewController.swift
//  AlexWeather
//
//  Created by Alex on 16.05.2023.
//
// TODO:  расставить MARKs

//  TODO: после нажатия серча появляется вью с тексфилдом (как в задаии с 5 филдами). туда вводиться город. после этого по АПИ получается результат, убирается вью и отображается пгода по этому городу


import UIKit
import CoreLocation
import SnapKit
import Network

final class MainViewController: UIViewController {
    
    private let searchViewContoller = SearchViewController()
    
    private let locationManager = CLLocationManager()
    
    private let backgroundView = UIImageView(image: UIImage(named: "image_background"))
    private let scrollView: UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    private let contentView = UIView()
    
    private let stoneView = StoneImageView()
    private let weatherInfoView = WeatherInfoView()
    
    private let searchButton = SearchButton()
    private let locationButton = LocationButton()
    
    private let infoButton = InfoButton()
    private let descriptionView  = DescriptionView()
    private let refreshControl = UIRefreshControl()
    
    private var topConstraint: Constraint?
    private var widthConstraint: Constraint?
    private var heightConstraint: Constraint?
    private var centerConstraint: Constraint?
    private var centerXConstraint: Constraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultConfiguration()
        setupUI()
        addTargets()
        startLocationManager()
    }
    
    private func setupUI() {
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.edges.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        contentView.addSubview(stoneView)
        stoneView.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.trailing.leading.equalTo(contentView).inset(60)
            make.top.equalTo(contentView).offset(-670) //(Constants.Constraints.stoneImageViewTopOffset)
        }
        
        
        
        
        view.addSubview(infoButton)
        infoButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(175)
            make.height.equalTo(85)
            make.bottom.equalToSuperview().inset(-25)
        }
        view.addSubview(weatherInfoView)
        weatherInfoView.snp.makeConstraints { make in
            make.bottom.equalTo(infoButton.snp.top).inset(-20)  // TODO: UPDATE
            make.trailing.leading.equalToSuperview().inset(10)
        }
        
        view.addSubview(locationButton)
        locationButton.snp.makeConstraints { make in
            make.left.equalTo(weatherInfoView).inset(80)
            make.bottom.equalTo(infoButton.snp.top).offset(-20)
            
        }
        
        view.addSubview(searchButton)
        searchButton.snp.makeConstraints { make in
            make.right.equalTo(weatherInfoView).inset(80)
            make.bottom.equalTo(view.snp.bottom).inset(80)
        }
        //
        
        view.addSubview(descriptionView)
        descriptionView.snp.makeConstraints { make in
            topConstraint = make.top.equalTo(infoButton.snp.bottom).priority(.high).constraint
            widthConstraint = make.width.equalTo(270).priority(.high).constraint
            heightConstraint = make.height.equalTo(400).priority(.high).constraint
            centerConstraint = make.center.equalToSuperview().priority(.low).constraint
            centerXConstraint = make.centerX.equalToSuperview().priority(.low).constraint
        }
        scrollView.refreshControl = refreshControl
    }
    
    private func defaultConfiguration() {
        view.backgroundColor = .white
        descriptionView.delegate = self
        scrollView.refreshControl = refreshControl
    }
    
    private func addTargets() {
        infoButton.addTarget(self, action: #selector(showInfo), for: .touchUpInside)
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    private func updateData(_ data: CompletionData) {
        let viewData = ViewData(temp: String(data.temperature) + "º", city: data.city, weather: data.weather)
        self.weatherInfoView.viewData = viewData
        stoneView.stoneState = .init(temperature: data.temperature,
                                     conditionCode: data.id,
                                     windSpeed: data.windSpeed)
    }
    
    private func flash() {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.2
        flash.fromValue = 1
        flash.toValue = 0.0
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        weatherInfoView.temperatureLabel.layer.add(flash, forKey: nil)
        weatherInfoView.conditionsLabel.layer.add(flash, forKey: nil)
    }
    
    private func startLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        DispatchQueue.global(qos: .userInitiated).async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
                self.locationManager.pausesLocationUpdatesAutomatically = false   //  why not TRUE?
                self.locationManager.startUpdatingLocation()
            }
        }
    }
    
    @objc private func showInfo() {
        self.topConstraint?.update(priority: .low)
        self.centerXConstraint?.update(priority: .low)
        self.centerConstraint?.update(priority: .high)
        self.infoButton.isHidden = true
        self.stoneView.isHidden = true
        self.locationButton.isHidden = true
        self.searchButton.isHidden = true
        self.weatherInfoView.isHidden = true
        UIView.animate(withDuration: 1) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func refresh(_ sender: AnyObject) {
        flash()
        guard let location = locationManager.location else { return }
        WeatherManager.shared.updateWeatherInfo(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude) { [weak self] completionData in guard let self else { return }
            self.updateData(completionData)
        }
        refreshControl.endRefreshing()
    }
    
    //    @objc private func search() {
    //        view.addSubview(searchView)
    //        searchView.snp.makeConstraints { make in
    //            make.center.equalToSuperview()
    //        }
    //
    //        print("lets search!")
    //    }
}

extension MainViewController: DescriptionViewDelegate {
    func hideInfo() {
        self.topConstraint?.update(priority: .high)
        self.centerXConstraint?.update(priority: .high)
        self.centerConstraint?.update(priority: .low)
        UIView.animate(withDuration: 1) {
            self.view.layoutIfNeeded()
        } completion: { [weak self] done in
            if done {
                guard let self else { return }
                self.infoButton.isHidden = false
                self.stoneView.isHidden = false
                self.locationButton.isHidden = false
                self.searchButton.isHidden = false
                self.weatherInfoView.isHidden = false
            }
        }
    }
}
extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else { return }
        WeatherManager.shared.updateWeatherInfo(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude) { [weak self] completionData in
            guard let self else { return }
            self.updateData(completionData)
        }
    }
}




