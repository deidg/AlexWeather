//
//  ViewController.swift
//  AlexWeather
//
//  Created by Alex on 16.05.2023.
//
//TODO: настроить проверку доступности CLLocation manager (https://developer.apple.com/documentation/corelocation/configuring_your_app_to_use_location_services#3384898)

import UIKit
import CoreLocation
import SnapKit
import Network
import MapKit

final class MainViewController: UIViewController {
    //MARK: Elements
    private let searchViewContoller = SearchViewController()
    private let citySearchManager = CitySearchManager()
    
    @objc private let locationManager = CLLocationManager()
    private let geoCoder = CLGeocoder()
    
    private var currentLatitude: Double = 0.0
    private var currentLongitude: Double = 0.0

    private let backgroundView = UIImageView(image: UIImage(named: "image_background"))
    private let scrollView: UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    private let contentView = UIView()
    
    private let stoneView = StoneImageView()
    private let weatherInfoView = WeatherInfoView()
    private var isStoneFalling = false
    private var emitterLayer: CAEmitterLayer?
    
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
    //MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultConfiguration()
        setupUI()
        addTargets()
        startLocationManager()
        makingNetworkMonitor()
    }
    //MARK: Items On View
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
            make.top.equalTo(contentView).offset(-670)
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
            make.bottom.equalTo(infoButton.snp.top).inset(-20)
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
 
    // MARK: Methods
    private func defaultConfiguration() {
        view.backgroundColor = .white
        descriptionView.delegate = self
        locationManager.delegate = self
        
        scrollView.refreshControl = refreshControl
    }
    
    private func addTargets() {
        infoButton.addTarget(self, action: #selector(showInfo), for: .touchUpInside)
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        searchButton.addTarget(self, action: #selector(openSearchViewController), for: .touchUpInside)
        locationButton.addTarget(self, action: #selector(updateLocation), for: .touchUpInside)
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
//                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
                self.locationManager.pausesLocationUpdatesAutomatically = false   //  why not TRUE?
                self.locationManager.startUpdatingLocation()
            }
        }
    }
    private func makingEmitterLayer() {
            emitterLayer = CAEmitterLayer()
            if let emitterLayer = emitterLayer {
                stoneView.layer.addSublayer(emitterLayer)
            }
            emitterLayer?.emitterPosition = CGPoint(x: stoneView.bounds.midX,
                                                    y: -10)
            emitterLayer?.emitterSize = CGSize(width: stoneView.bounds.width,
                                               height: 0)
            emitterLayer?.emitterShape = .line
        }
    
    private func fallAnimation() {
            guard !isStoneFalling else { return }
            let animation = CAKeyframeAnimation(keyPath: "position")
            animation.duration = 3.0
            animation.repeatCount = 0.0
            animation.timingFunction = CAMediaTimingFunction(name: .easeIn)
            animation.values = [
                NSValue(cgPoint: stoneView.center),
                NSValue(cgPoint: CGPoint(x: stoneView.center.x, y: view.bounds.height + stoneView.bounds.height))
            ]
            animation.keyTimes = [0, 1]
            animation.delegate = self
        stoneView.layer.add(animation, forKey: "fallAnimation")
            isStoneFalling = true
        }
    
    private func showStoneImage() {
            stoneView.isHidden = false
            isStoneFalling = false
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
        makingNetworkMonitor()
        guard let location = locationManager.location else { return }
        
        WeatherManager.shared.updateWeatherInfo(latitude: currentLatitude, longitude: currentLongitude) { [weak self] completionData in guard let self else { return }
        
            self.updateData(completionData)
        }
        refreshControl.endRefreshing()
    }
    
    @objc func makingNetworkMonitor() {
            let monitor = NWPathMonitor()
            monitor.pathUpdateHandler = { path in
                DispatchQueue.main.async {
                    if path.status == .satisfied {
                        self.showStoneImage()
                        print("Internet connection is available.")
                    } else {
                        self.fallAnimation()
                        print("Internet connection is lost.")
                    }
                }
            }
            let queue = DispatchQueue.main
            monitor.start(queue: queue)
        }
    
       
    private func handleSelectedCity(_ cityName: String, _ latitude: Double, _ longitude: Double) {
        // Send the selected city data to WeatherManager and update the weather info
        WeatherManager.shared.updateWeatherInfo(latitude: latitude, longitude: longitude) { [weak self] completionData in
            DispatchQueue.main.async {
                // Update UI with the received weather data
                self?.updateData(completionData)
            }
        }
        // Handle the selected city data as needed
        print("Selected City: \(cityName), Latitude: \(latitude), Longitude: \(longitude)")
    }


    
    @objc private func updateLocation() {
        locationManager.startUpdatingLocation()
        print("your current longitude - \(String(describing: locationManager.location?.coordinate.longitude))")
        print("your current latitude - \(String(describing: locationManager.location?.coordinate.latitude))")
    }
    
    
    func didSelectCity(cityName: String, latitude: Double, longitude: Double) {
        // Handle the selected city data here
        handleSelectedCity(cityName, latitude, longitude)
    }
    
    @objc private func openSearchViewController() {
        let searchViewController = SearchViewController()
        searchViewController.searchVCDelegate = self
        self.present(searchViewController, animated: true)
    }
    
    
    
}

// MARK: extensions - DescriptionViewDelegate
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
// MARK: extensions - CLLocationManagerDelegate
extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])  {
        guard let lastLocation = locations.last else { return }
        
        currentLatitude = lastLocation.coordinate.latitude
        currentLongitude = lastLocation.coordinate.longitude
        
        
        WeatherManager.shared.updateWeatherInfo(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude) { [weak self] completionData in
            guard let self else { return }
            self.updateData(completionData)
        }
    }
}
extension MainViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            stoneView.isHidden = true
        }
    }
}

// MARK: extensions - SearchDataDelegate
extension MainViewController: SearchViewControllerDelegate {
    
    func didSelectLocation(latitude: Double, longitude: Double) {
          // Handle the selected location data here
          // You can update weather information using WeatherManager.shared.updateWeatherInfo
          WeatherManager.shared.updateWeatherInfo(latitude: latitude, longitude: longitude) { [weak self] completionData in
              DispatchQueue.main.async {
                  // Update UI with the received weather data
                  self?.updateData(completionData)
              }
          }
      }
    
    
//    func transferSearchData(_ cityName: String) {
//
//            print("cityName from search - \(cityName)")
//
//            WeatherManager.shared.updateWeatherInfobyCityName(cityName: cityName) { [weak self] searchCompletionData in
//                if let searchCompletionData = searchCompletionData {
//                    WeatherManager.shared.updateWeatherInfo(latitude: searchCompletionData.lat, longitude: searchCompletionData.lon) { [weak self] completionData in
//                        guard let self = self else { return }
//                        self.updateData(completionData)
//
//                        self.currentLatitude = searchCompletionData.lat
//                        self.currentLongitude = searchCompletionData.lon
//                    }
//                }
//            }
//        }
}
