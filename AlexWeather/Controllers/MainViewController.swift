//
//  ViewController.swift
//  AlexWeather
//
//  Created by Alex on 16.05.2023.
//
// TODO:  расставить MARKs



import UIKit
import CoreLocation
import SnapKit
import Network

class MainViewController: UIViewController {
    
    private let locationManager = CLLocationManager()
    
    private let backgroundView = UIImageView(image: UIImage(named: "image_background"))
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let stoneView = StoneImageView()
    private let weatherInfoView = WeatherInfoView()
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
            make.top.equalToSuperview()
            make.trailing.leading.equalTo(contentView).inset(60)
        }
        view.addSubview(weatherInfoView)
        weatherInfoView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(450)  // TODO: UPDATE
            make.trailing.leading.equalToSuperview().inset(10)
        }
        view.addSubview(infoButton)
        infoButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(175)
            make.height.equalTo(85)
            make.bottom.equalToSuperview().inset(-25)
        }
        view.addSubview(descriptionView)
        descriptionView.snp.makeConstraints { make in
            topConstraint = make.top.equalTo(infoButton.snp.bottom).priority(.high).constraint
            widthConstraint = make.width.equalTo(270).priority(.high).constraint
            heightConstraint = make.height.equalTo(400).priority(.high).constraint
            centerXConstraint = make.center.equalToSuperview().priority(.low).constraint
            centerXConstraint = make.centerX.equalToSuperview().priority(.low).constraint
        }
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
    
    private func startLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.pausesLocationUpdatesAutomatically = false   //  why not TRUE?
            locationManager.startUpdatingLocation()
            
        }
    }
    
    @objc private func showInfo() {
        self.topConstraint?.update(priority: .low)
        self.centerXConstraint?.update(priority: .low)
        self.centerConstraint?.update(priority: .high)
        self.infoButton.isHidden = true
        self.stoneView.isHidden = true
        self.weatherInfoView.isHidden = true
        UIView.animate(withDuration: 1) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func refresh(_ sender: AnyObject) {
        guard let location = locationManager.location else { return }
        WeatherManager.shared.updateWeatherInfo(latitude: location.coordinate.latitude, longtitude: location.coordinate.longitude) { [weak self] completionData in guard let self else { return }
            self.updateData(completionData)
        }
        refreshControl.endRefreshing()
    }
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
                self.weatherInfoView.isHidden = false
            }
        }
    }
}
extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else { return }
        WeatherManager.shared.updateWeatherInfo(latitude: lastLocation.coordinate.latitude, longtitude: lastLocation.coordinate.longitude) { [weak self] completionData in
            guard let self else { return }
            self.updateData(completionData)
        }
    }
}




