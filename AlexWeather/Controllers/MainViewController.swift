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

class MainViewController: UIViewController {
    //MARK: elements
    private let infoViewController = InfoViewController()
    private let infoButton = InfoButton()
    private let weatherManager = WeatherManager()
    private let locationManager = CLLocationManager()
    private var networkMonitor: NWPathMonitor?
    private var emitterLayer: CAEmitterLayer?
    private let refreshControl = UIRefreshControl()
    private var windSpeed: Double = 0.0
    
    private var isConnected: Bool = true
    
    private var state: State = .normal(windSpeed: 0.0) {
        didSet {
            updateWeatherState(state, windSpeed, isConnected)
        }
    }
    private let locationPinIcon = UIImageView(image: UIImage(named: Constants.Icons.locationPinIcon))
    private let searchIcon = UIImageView(image: UIImage(named: Constants.Icons.searchIcon))
    private let backgroundView: UIImageView = {
        let backgroundView = Constants.Images.backgroundView
        backgroundView.contentMode = .scaleAspectFill
        return backgroundView
    }()
    private let scrollView: UIScrollView = {
        var view = UIScrollView()
        view.isScrollEnabled = true
        view.alwaysBounceVertical = true
        return view
    }()
    private let contentView = UIView()
    private var stoneImageView:  UIImageView = {
       let stoneImageView = UIImageView()
        
        
       
        return stoneImageView
    }()
    private let temperatureLabel: UILabel = {
        let temperatureLabel = UILabel()
        temperatureLabel.font = UIFont(name: Constants.Text.temperatureLabelFontName, size: Constants.Text.temperatureLabelFontSize)
        temperatureLabel.textColor = .black
        temperatureLabel.textAlignment = .left
        return temperatureLabel
    }()
    private let conditionsLabel: UILabel = {
        let conditionsLabel = UILabel()
        conditionsLabel.textColor = .black
        conditionsLabel.font = UIFont(name: Constants.Text.conditionsLabelFontName, size: Constants.Text.conditionsLabelFontSize)
        return conditionsLabel
    }()
    private let locationLabel: UILabel = {
        let locationLabel = UILabel()
        locationLabel.textAlignment = .center
        return locationLabel
    }()
    let infoButtonShadowView: UIView = {
        let infoButtonShadow = UIView()
        infoButtonShadow.backgroundColor = UIColor.yellow
        infoButtonShadow.layer.shadowColor = UIColor.black.cgColor
        infoButtonShadow.layer.shadowOpacity = Constants.Shadows.infoButtonShadowOpacity
        infoButtonShadow.layer.shadowOffset = CGSize(width: Constants.Shadows.infoButtonShadowOffsetWidth, height: Constants.Shadows.infoButtonShadowOffsetHeight)
        infoButtonShadow.layer.shadowRadius = Constants.Shadows.infoButtonShadowShadowRadius
        infoButtonShadow.layer.cornerRadius = Constants.Shadows.infoButtonShadowCornerRadius
        return infoButtonShadow
    }()
    
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addTargets()
        startLocationManager()
        startNetworkMonitoring()
    }
    // MARK: methods
    private func setupUI() {
         emitterLayer = CAEmitterLayer()

        if let emitterLayer = emitterLayer {
           stoneImageView.layer.addSublayer(emitterLayer)
         }
        
        
        
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
            make.centerX.equalTo(scrollView)
            make.top.bottom.equalTo(scrollView).offset(Constants.Constraints.contentViewTopBottomOffset)
        }
        contentView.addSubview(stoneImageView)
        stoneImageView.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.trailing.leading.equalTo(contentView)
            make.top.equalTo(contentView).offset(Constants.Constraints.stoneImageViewTopOffset)
        }
        view.addSubview(temperatureLabel)
        temperatureLabel.snp.makeConstraints{ make in
            make.bottom.equalTo(view.snp.bottom).inset(Constants.Constraints.temperatureLabelBottom)
            make.leading.equalToSuperview().inset(Constants.Constraints.temperatureLabelLeading)
            make.trailing.equalToSuperview().inset(Constants.Constraints.temperatureLabelTrailing)
            make.height.equalTo(Constants.Constraints.temperatureLabelHeight)
        }
//        view.addSubview(conditionsLabel)
//        conditionsLabel.snp.makeConstraints{ make in
//
//            make.top.equalTo(view.snp.top).inset(Constants.Constraints.conditionsLabelToTop)
//
//            make.leading.equalToSuperview().inset(Constants.Constraints.conditionsLabelBottomLeading)
//            make.trailing.equalToSuperview().inset(Constants.Constraints.conditionsLabelBottomTrailing)
//            make.height.equalTo(Constants.Constraints.conditionsLabelBottomHeight)
//        }
        view.addSubview(locationLabel)
        locationLabel.snp.makeConstraints{ make in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(view.snp.bottom).inset(Constants.Constraints.locationLabelBottom)
            make.leading.trailing.equalToSuperview().inset(Constants.Constraints.locationLabelLeadingTrailing)
            make.height.equalTo(Constants.Constraints.locationLabelHeight)
        }
        
        view.addSubview(infoButtonShadowView)
        infoButtonShadowView.snp.makeConstraints{ make in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(view.snp.bottom).inset(Constants.Constraints.infoButtonShadowViewBottom)
            make.leading.trailing.equalToSuperview().inset(Constants.Constraints.infoButtonShadowViewLeadingTrailing)
            make.height.equalTo(Constants.Constraints.infoButtonShadowViewHeight)
        }
        view.addSubview(infoButton)
        infoButton.snp.makeConstraints{ make in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(view.snp.bottom).inset(Constants.Constraints.infoButtonBottom)
            make.leading.trailing.equalToSuperview().inset(Constants.Constraints.infoButtonLeadingTrailing)
            make.height.equalTo(Constants.Constraints.infoButtonHeight)
        }
        view.addSubview(locationPinIcon)
        locationPinIcon.snp.makeConstraints{ make in
            make.bottom.equalTo(view.snp.bottom).inset(Constants.Constraints.locationPinIconBottom)
            make.leading.equalTo(locationLabel).inset(Constants.Constraints.locationPinIconLeading)
            make.height.equalTo(Constants.Constraints.locationPinIconHeight)
        }
        view.addSubview(searchIcon)
        searchIcon.snp.makeConstraints{ make in
            make.bottom.equalTo(view.snp.bottom).inset(Constants.Constraints.searchIconBottom)
            make.trailing.equalTo(locationLabel).offset(Constants.Constraints.searchIconTrailing)
            make.height.equalTo(Constants.Constraints.searchIconHeight)
        }
        
        emitterLayer?.emitterPosition = CGPoint(x: stoneImageView.bounds.midX, y: -10)
        emitterLayer?.emitterSize = CGSize(width: stoneImageView.bounds.width, height: 0)
        emitterLayer?.emitterShape = .line
        
    }
    
    private func addTargets() {  // устанавливает селекторы на кнопки и движения
        infoButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        refreshControl.addTarget(self, action: #selector(refreshAction(sender:)), for: UIControl.Event.valueChanged)
//        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(makingNetworkMonitor),
//                             userInfo: nil, repeats: true)
    }
    
    private func startLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        DispatchQueue.global(qos: .userInitiated).async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
                self.locationManager.pausesLocationUpdatesAutomatically = false
                self.locationManager.startUpdatingLocation()
            }
        }
    }
    
    private func updateWeatherState(_ state: State, _ windSpeed: Double, _ internetConnection: Bool) { // регулирует состояния
        switch state {
        case .noInternet:
            stoneImageView.isHidden = true
        case .normal(windSpeed: let windSpeed) where windSpeed > Constants.Conditions.windSpeedLimit:
            stoneImageView.image = UIImage(named: Constants.Stones.normalStoneImage)
            stoneImageView.alpha = Constants.Conditions.alphaStandart
            windAnimationRotate()
        case .wet(windSpeed: let windSpeed) where windSpeed > Constants.Conditions.windSpeedLimit:
            stoneImageView.image = UIImage(named: Constants.Stones.wetStoneImage)
            stoneImageView.alpha = Constants.Conditions.alphaStandart
            windAnimationRotate()
        case .snow(windSpeed: let windSpeed) where windSpeed > Constants.Conditions.windSpeedLimit:
            stoneImageView.image = UIImage(named: Constants.Stones.snowStoneImage)
            stoneImageView.alpha = Constants.Conditions.alphaStandart
            windAnimationRotate()
        case .cracks(windSpeed: let windSpeed) where windSpeed > Constants.Conditions.windSpeedLimit:
            stoneImageView.image = UIImage(named: Constants.Stones.cracksStoneImage)
            stoneImageView.alpha = Constants.Conditions.alphaStandart
            windAnimationRotate()
        case .fog(windSpeed: let windSpeed) where windSpeed > Constants.Conditions.windSpeedLimit:
            stoneImageView.image =  UIImage(named: Constants.Stones.normalStoneImage)
            stoneImageView.alpha = Constants.Conditions.alphaMist
            windAnimationRotate()
        case .cracks:
            stoneImageView.image = UIImage(named: Constants.Stones.cracksStoneImage)
            stoneImageView.alpha = Constants.Conditions.alphaStandart
        case .wet:
            stoneImageView.image = UIImage(named: Constants.Stones.wetStoneImage)
            stoneImageView.alpha = Constants.Conditions.alphaStandart
        case .snow:
            stoneImageView.image = UIImage(named: Constants.Stones.snowStoneImage)
            stoneImageView.alpha = Constants.Conditions.alphaStandart
        case .fog:
            stoneImageView.image = UIImage(named: Constants.Stones.normalStoneImage)
            stoneImageView.alpha = Constants.Conditions.alphaMist
        case .normal:
            stoneImageView.image = UIImage(named: Constants.Stones.normalStoneImage)
            stoneImageView.alpha = Constants.Conditions.alphaStandart
        }
    }
    
    private func updateData(_ data: CompletionData, isConnected: Bool) {
        state = .init(data.temperature, data.id, data.windSpeed, isConnected)
        print("from uppdateData")
        print(state)
    }
    
    private func windAnimationRotate() {
        let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        animation.duration = 4
        animation.fillMode = .both
        animation.repeatCount = .infinity
        animation.values = [0, Double.pi/50, 0, -(Double.pi/50), 0 ]
        animation.keyTimes = [NSNumber(value: 0.0),
                              NSNumber(value: 0.3),
                              NSNumber(value: 0.5),
                              NSNumber(value: 0.8),
                              NSNumber(value: 1.0)
        ]
        stoneImageView.layer.add(animation, forKey: "rotate")
    }
    
    
//    private func fallAnimation() {
//        let emitterLayer = CAEmitterLayer()
//        emitterLayer.emitterPosition = CGPoint(x: stoneImageView.bounds.midX, y: -10) // Position of the emitter at the top of the stoneImageView
//        let cell = CAEmitterCell()
//        cell.birthRate = 10
//        cell.lifetime = 1
//        cell.velocity = 100
//        cell.scale = 0.1
//        cell.emissionRange = CGFloat.pi * 2.0
//        cell.contents = UIImage(named: Constants.Stones.normalStoneImage)?.cgImage // Use the stone image for the particles
//        emitterLayer.emitterCells = [cell]
//        stoneImageView.layer.addSublayer(emitterLayer)
//    }
    
    
//    private func fallAnimation () {
//        let emitterLayer = CAEmitterLayer()
//            emitterLayer.emitterPosition = CGPoint(x: 200, y: 200)
//            let cell = CAEmitterCell()
//            cell.birthRate = 10
//            cell.lifetime = 1
//            cell.velocity = 100
//            cell.scale = 0.1
//
//            cell.emissionRange = CGFloat.pi * 2.0
//            cell.contents = stoneImageView)
//            emitterLayer.emitterCells = [cell]
//
//            view.layer.addSublayer(emitterLayer)
//
//    }
    
    private func flash() {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.2
        flash.fromValue = 1
        flash.toValue = 0.0
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        temperatureLabel.layer.add(flash, forKey: nil)
        conditionsLabel.layer.add(flash, forKey: nil)
    }
    //MARK: OBJC methods
    @objc private func buttonPressed(sender: UIButton) {  // нажатие кнопки INFO
        infoViewController.modalPresentationStyle = .pageSheet
        present(infoViewController, animated: true )
    }
    
    private func startNetworkMonitoring() {
        networkMonitor = NWPathMonitor()
        networkMonitor?.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    self.stoneImageView.isHidden = false
                } else {
                    // Internet connection lost, trigger fallAnimation()
                    self.fallAnimation()
                }
            }
        }
        let queue = DispatchQueue(label: "NetworkMonitorQueue")
        networkMonitor?.start(queue: queue)
    }
    
    
    
    
    // РАБОЧИЙ КОД НИЖЕ
//    @objc func makingNetworkMonitor() {
//        let monitor = NWPathMonitor()
//        monitor.pathUpdateHandler = { path in
//            if path.status == .satisfied {
//                self.stoneImageView.isHidden = false
//            } else {
////                self.stoneImageView.isHidden = true
//                self.fallAnimation()
//
//            }
//        }
//        let queue = DispatchQueue.main
//        monitor.start(queue: queue)
//    }
    
    @objc func refreshAction(sender: AnyObject) {  // ОБНОВЛЯЕТ данные на экране
        flash()
        self.weatherManager.updateWeatherInfo(latitude: self.locationManager.location?.coordinate.latitude ?? 0.0, longtitude: self.locationManager.location?.coordinate.longitude ?? 0.0)
        { completionData in
            let temprature = completionData.temperature
            let conditionCode = completionData.id
            let windSpeed = completionData.windSpeed
            let isConnected = self.isConnected
            self.state = .init(temprature, conditionCode, windSpeed, isConnected)
        }
        refreshControl.endRefreshing()
    }
    
    private func fallAnimation() {
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.duration = 3.0
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        animation.values = [
            NSValue(cgPoint: stoneImageView.center),
            NSValue(cgPoint: CGPoint(x: stoneImageView.center.x, y: view.bounds.height + stoneImageView.bounds.height))
        ]
        animation.keyTimes = [0, 1]
        stoneImageView.layer.add(animation, forKey: "fallAnimation")
    }

    
}

//MARK: extension MainViewController
extension MainViewController {
    enum State: Equatable {
        case cracks(windSpeed: Double)
        case wet(windSpeed: Double)
        case snow(windSpeed: Double)
        case fog(windSpeed: Double)
        case normal(windSpeed: Double)
        case noInternet
        init(_ temperature: Int, _ conditionCode: Int, _ windSpeed: Double, _ internetConnection: Bool) {
            if internetConnection == true {
                if temperature > Constants.Conditions.temprature {
                    self = .cracks(windSpeed: windSpeed)
                    print("its cracks case!")
                } else if temperature < Constants.Conditions.temprature && conditionCode >= 100 && conditionCode <= 531 {
                    self = .wet(windSpeed: windSpeed)
                    print("its wet case!")
                } else if temperature < Constants.Conditions.temprature && conditionCode >= 600 && conditionCode <= 622 {
                    self = .snow(windSpeed: windSpeed)
                    print("its snow case!")
                } else if temperature < Constants.Conditions.temprature && conditionCode >= 701 && conditionCode <= 781 {
                    self = .fog(windSpeed: windSpeed)
                    print("its fog case!")
                } else if temperature < Constants.Conditions.temprature && conditionCode >= 800 && conditionCode <= 805 {
                    self = .normal(windSpeed: windSpeed)
                    print("its normal case! And Windy")
                } else {
                    self = .normal(windSpeed: windSpeed)
                    print("you§re here and conditionCode! - \(conditionCode)")
                }
            } else {
                self = .noInternet
            }
        }
    }
}

//MARK: LocationManagerDelegate
extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else { return }
        weatherManager.updateWeatherInfo(latitude: lastLocation.coordinate.latitude, longtitude: lastLocation.coordinate.longitude) { complitionData in
            let weatherConditions = complitionData.weather
            let temperature = String(complitionData.temperature)
            let city = complitionData.city
            let country = complitionData.country
            let windSpeedData = complitionData.windSpeed
            let responseStatusCode = complitionData.weather
            DispatchQueue.main.async { [self] in
                self.temperatureLabel.text = temperature + "°"
                self.conditionsLabel.text = weatherConditions
                self.locationLabel.text = city + ", " + country
                self.updateData(complitionData, isConnected: isConnected)
                self.windSpeed = windSpeedData
                
                print("windspeed m/sec - \(windSpeedData)")
                scrollView.refreshControl = refreshControl
                print("response status code - \(responseStatusCode)")
            }
        }
    }
}

//MARK: Constants
extension MainViewController {
    enum Constants {
        enum Text {
            static let labelTextColor = UIColor(red: 102/255, green: 178/255, blue: 255/255, alpha: 1)
            static let temperatureLabelFontName = "SFProDisplay-Bold"
            static let temperatureLabelFontSize: CGFloat = 83
            static let conditionsLabelFontName = "Ubuntu-Regular"
            static let conditionsLabelFontSize: CGFloat = 36
        }
        enum Shadows {
            static let infoButtonShadowOpacity: Float = 1
            static let infoButtonShadowOffsetWidth = 2
            static let infoButtonShadowOffsetHeight = 2
            static let infoButtonShadowShadowRadius: CGFloat = 1
            static let infoButtonShadowCornerRadius: CGFloat = 15
        }
        enum Constraints {
            static let contentViewTopBottomOffset = -60
            static let stoneImageViewTopOffset = -570
            
            static let temperatureLabelBottom = 300
            static let temperatureLabelLeading = 20
            static let temperatureLabelTrailing = 200
            static let temperatureLabelHeight = 100
            
//            static let conditionsLabelToTop = 100
//            static let conditionsLabelBottomLeading = 20
//            static let conditionsLabelBottomTrailing = 100
//            static let conditionsLabelBottomHeight = 50
            
            static let locationLabelBottom = 70
            static let locationLabelLeadingTrailing = 100
            static let locationLabelHeight = 50
            
            static let infoButtonShadowViewBottom = -20
            static let infoButtonShadowViewLeadingTrailing = 100
            static let infoButtonShadowViewHeight = 70
            
            static let infoButtonBottom = -20
            static let infoButtonLeadingTrailing = 100
            static let infoButtonHeight = 70
            
            static let locationPinIconBottom = 80
            static let locationPinIconLeading = -30
            static let locationPinIconHeight = 20
            
            static let searchIconBottom = 80
            static let searchIconTrailing = 30
            static let searchIconHeight = 20
        }
        enum Conditions {
            static let windSpeedLimit = 3.0
            static let alphaStandart = 1.0
            static let alphaMist = 0.3
            
            static let temprature = 30
        }
        enum Stones {
            static let normalStoneImage = "image_stone_normal.png"
            static let wetStoneImage = "image_stone_wet.png"
            static let snowStoneImage = "image_stone_snow.png"
            static let cracksStoneImage = "image_stone_cracks.png"
        }
        enum Icons {
            static let locationPinIcon = "icon_location.png"
            static let searchIcon = "icon_search.png"
        }
        enum Images {
            static let backgroundView = UIImageView(image: UIImage(named: "image_background.png"))
        }
        enum Borders {
            static let frameBorderColor = UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1).cgColor
        }
        enum Colors {
            static let mainBackgroundColor = UIColor(red: 160/255, green: 160/255, blue: 160/255, alpha: 1)
            static let firstCellBackgroundColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1)
        }
    }
}
