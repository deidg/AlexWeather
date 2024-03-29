//
//  ViewController.swift
//  AlexWeather
//
//  Created by Alex on 16.05.2023.
//

import UIKit
import CoreLocation
import SnapKit
import Network
import MapKit

final class MainViewController: UIViewController {
    //MARK: Classes
    private let searchViewContoller = SearchViewController()
    private let citySearchManager = CitySearchManager()
    //MARK: MainVC elements
    private let backgroundView = Constants.Elements.backgroundViewImage
    private let scrollView: UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    private var searchButton: UIButton = {
        var searchButton = UIButton()
        searchButton.frame = Constants.Sizes.searchAndLocationButtonSize
        searchButton.setImage((Constants.Elements.searchButtonImage), for: .normal)
        return searchButton
    }()
    private var locationButton: UIButton = {
        var locationButton = UIButton()
        locationButton.frame = Constants.Sizes.searchAndLocationButtonSize
        locationButton.setImage((Constants.Elements.locationButtonImage), for: .normal)
        return locationButton
    }()
    private let infoButton = InfoButton()
    private let descriptionView  = DescriptionView()
    private let weatherInfoView = WeatherInfoView()
    //MARK: Stone elements
    private let contentView = UIView()
    private let stoneView = StoneImageView()
    private var emitterLayer: CAEmitterLayer?
    private let refreshControl = UIRefreshControl()
    //MARK: variables
    private var isStoneFalling = true
    private var topConstraint: Constraint?
    private var widthConstraint: Constraint?
    private var heightConstraint: Constraint?
    private var centerConstraint: Constraint?
    private var centerXConstraint: Constraint?
    //MARK: GEO elements
    private let locationManager = CLLocationManager()
    private let geoCoder = CLGeocoder()
    private var currentLatitude: Double = 0.0
    private var currentLongitude: Double = 0.0
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
            make.horizontalEdges.equalTo(contentView).inset(60)
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
            make.horizontalEdges.equalToSuperview().inset(10)
            make.bottom.equalTo(infoButton.snp.top).inset(-20)
        }
        view.addSubview(locationButton)
        locationButton.snp.makeConstraints { make in
            make.left.equalTo(weatherInfoView).inset(Constants.Sizes.screenIndentFromSize)
            make.bottom.equalTo(infoButton.snp.top).offset(-20)
        }
        view.addSubview(searchButton)
        searchButton.snp.makeConstraints { make in
            make.right.equalTo(weatherInfoView).inset(Constants.Sizes.screenIndentFromSize)
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
        weatherInfoView.layer.add(flash, forKey: nil)
    }
    
    private func startLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        DispatchQueue.global(qos: .userInitiated).async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
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
        guard isStoneFalling == true else { return }  // CHANGE
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
        isStoneFalling = false
    }
    
    private func showStoneImage() {
        stoneView.isHidden = false
        isStoneFalling = true
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
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func refresh(_ sender: AnyObject) {
        flash()
        makingNetworkMonitor()
        WeatherManager.shared.updateWeatherInfo(latitude: currentLatitude, longitude: currentLongitude) { [weak self] completionData in
            guard let self else { return }
            self.updateData(completionData)
        }
        refreshControl.endRefreshing()
    }
    
    @objc func makingNetworkMonitor() {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    self?.showStoneImage()
                } else {
                    self?.fallAnimation()
                }
            }
        }
        let queue = DispatchQueue.main
        monitor.start(queue: queue)
    }
    
    @objc private func updateLocation() {
        flash()
        WeatherManager.shared.updateWeatherInfo(latitude: currentLatitude, longitude: currentLongitude) { [weak self] completionData in
            guard let self else { return }
                DispatchQueue.main.async {
                    self.updateData(completionData)
                }
            }
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
        UIView.animate(withDuration: 0.5) {
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
// MARK: extensions - CAAnimationDelegate
extension MainViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            stoneView.isHidden = true
        }
    }
}
// MARK: extensions - SearchViewControllerDelegate
extension MainViewController: SearchViewControllerDelegate {
    func didSelectLocation(latitude: Double, longitude: Double) {
        WeatherManager.shared.updateWeatherInfo(latitude: latitude, longitude: longitude)
        { [weak self] completionData in
            guard let self else { return }
            DispatchQueue.main.async {
                self.updateData(completionData)
            }
        }
    }
}
extension MainViewController {
    enum Constants {
        enum Elements {
            static let backgroundViewImage = UIImageView(image: UIImage(named: "image_background"))
            static let searchButtonImage = UIImage(named: "icon_search")
            static let locationButtonImage = UIImage(named: "icon_location")
        }
        enum Sizes {
            static let searchAndLocationButtonSize = CGRect(x: 0, y: 0, width: 120, height: 120)
            static let screenIndentFromSize = 80
        }
    }
}

