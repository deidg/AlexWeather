//
//  ViewController.swift
//  AlexWeather
//
//  Created by Alex on 16.05.2023.
//

 10 мин
// TODO: вынести все цифры в константы
//  при дергании камня (рефреше) - сделать мерцание цифр? погасить на 0.5 - 1 сек

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
    private let refreshControl = UIRefreshControl()
    private var windSpeed: Double = 0.0
    
    private var isConnected: Bool = true
    private var infoButtonPressed: Bool = false
    
    private var state: State = .normal(windSpeed: 0.0) {
        didSet {
            updateWeatherState(state, windSpeed, isConnected)
        }
    }
    
    private let locationPinIcon = UIImageView(image: UIImage(named: "icon_location.png"))
    private let searchIcon = UIImageView(image: UIImage(named: "icon_search.png"))
    private let backgroundView: UIImageView = {
        let backgroundView = UIImageView(image: UIImage(named: "image_background.png"))
        backgroundView.contentMode = .scaleAspectFill
        return backgroundView
    }()
    private let scrollView: UIScrollView = {
        var view = UIScrollView()
        view.isScrollEnabled = true
        view.alwaysBounceVertical = true
        return view
    }()
    private let contentView: UIView = {
        let view = UIView()
        return view
    }()
    private var stoneImageView: UIImageView = {
        let stoneImageView = UIImageView()
        return stoneImageView
    }()
    private let temperatureLabel: UILabel = {
        let temperatureLabel = UILabel()
        temperatureLabel.font = UIFont(name: "SFProDisplay-Bold", size: 83)
        temperatureLabel.textColor = .black
        temperatureLabel.textAlignment = .left
        return temperatureLabel
    }()
    private let conditionsLabel: UILabel = {
        let conditionsLabel = UILabel()
        conditionsLabel.textColor = .black
        conditionsLabel.font = UIFont(name: "Ubuntu-Regular", size: 36)
        return conditionsLabel
    }()
    private let locationLabel: UILabel = {
        let locationLabel = UILabel()
        locationLabel.text = "anywhere"  //     удалить в конце!!!
        locationLabel.textAlignment = .center
        return locationLabel
    }()
    
    let infoButtonShadowView: UIView = {
            let infoButtonShadow = UIView()
            infoButtonShadow.backgroundColor = UIColor.yellow
            infoButtonShadow.layer.shadowColor = UIColor.black.cgColor
        infoButtonShadow.layer.shadowOpacity = 1// 0.25
            infoButtonShadow.layer.shadowOffset = CGSize(width: 2, height: 2)
            infoButtonShadow.layer.shadowRadius = 5
            infoButtonShadow.layer.cornerRadius = 15
            return infoButtonShadow
        }()
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addTargets()
        startLocationManager()
    }
    // MARK: methods
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
            make.centerX.equalTo(scrollView)
            make.top.bottom.equalTo(scrollView).offset(-60)
        }
        contentView.addSubview(stoneImageView)
        stoneImageView.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.trailing.leading.equalTo(contentView)
            make.top.equalTo(contentView).offset(-570)
        }
        view.addSubview(temperatureLabel)
        temperatureLabel.snp.makeConstraints{ make in
            make.bottom.equalTo(view.snp.bottom).inset(300)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(200)
            make.height.equalTo(100)
        }
        view.addSubview(conditionsLabel)
        conditionsLabel.snp.makeConstraints{ make in
            make.bottom.equalTo(view.snp.bottom).inset(250)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(100)
            make.height.equalTo(50)
        }
        view.addSubview(locationLabel)
        locationLabel.snp.makeConstraints{ make in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(view.snp.bottom).inset(70)
            make.leading.trailing.equalToSuperview().inset(100)
            make.height.equalTo(50)
        }
 
        view.addSubview(infoButtonShadowView)
        infoButtonShadowView.snp.makeConstraints{ make in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(view.snp.bottom).inset(-20)
            make.leading.trailing.equalToSuperview().inset(100)
            make.height.equalTo(70)
        }
        
        view.addSubview(infoButton)
        infoButton.snp.makeConstraints{ make in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(view.snp.bottom).inset(-20)
            make.leading.trailing.equalToSuperview().inset(100)
            make.height.equalTo(70)
        }
        
        view.addSubview(locationPinIcon)
        locationPinIcon.snp.makeConstraints{ make in
            make.bottom.equalTo(view.snp.bottom).inset(80)
            make.leading.equalTo(locationLabel).inset(-30)
            make.height.equalTo(20)
        }
        view.addSubview(searchIcon)
        searchIcon.snp.makeConstraints{ make in
            make.bottom.equalTo(view.snp.bottom).inset(80)
            make.trailing.equalTo(locationLabel).offset(30)
            make.height.equalTo(20)
        }
    }
    private func addTargets() {  // устанавливаем селекторы на кнопки и движения
        infoButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        refreshControl.addTarget(self, action: #selector(refreshAction(sender:)), for: UIControl.Event.valueChanged)
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(makingNetworkMonitor),
                             userInfo: nil, repeats: true)
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
        case .normal(windSpeed: let windSpeed) where windSpeed > 3.0:
            stoneImageView.image = UIImage(named: "image_stone_normal.png")
            stoneImageView.alpha = 1
            windAnimationRotate()
        case .wet(windSpeed: let windSpeed) where windSpeed > 3.0:
            stoneImageView.image = UIImage(named: "image_stone_wet.png")
            stoneImageView.alpha = 1
            windAnimationRotate()
        case .snow(windSpeed: let windSpeed) where windSpeed > 3.0:
            stoneImageView.image = UIImage(named: "image_stone_snow.png")
            stoneImageView.alpha = 1
            windAnimationRotate()
        case .cracks(windSpeed: let windSpeed) where windSpeed > 3.0:
            stoneImageView.image = UIImage(named: "image_stone_cracks.png")
            stoneImageView.alpha = 1
            windAnimationRotate()
        case .fog(windSpeed: let windSpeed) where windSpeed > 3.0:
            stoneImageView.image =  UIImage(named: "image_stone_normal.png")
            stoneImageView.alpha = 0.3
            windAnimationRotate()
        case .cracks: // (windSpeed: let windSpeed):
            stoneImageView.image = UIImage(named: "image_stone_cracks.png")
            stoneImageView.alpha = 1
        case .wet: //(windSpeed: let windSpeed):
            stoneImageView.image = UIImage(named: "image_stone_wet.png")
            stoneImageView.alpha = 1
        case .snow: //(windSpeed: let windSpeed):
            stoneImageView.image = UIImage(named: "image_stone_snow.png")
            stoneImageView.alpha = 1
        case .fog:  //(windSpeed: let windSpeed):
            stoneImageView.image = UIImage(named: "image_stone_normal.png")
            stoneImageView.alpha = 0.3
        case .normal: //(windSpeed: let windSpeed):
            stoneImageView.image = UIImage(named: "image_stone_normal.png")
            stoneImageView.alpha = 1
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
        animation.values = [0, Double.pi/50, 0, -(Double.pi/50), 0 ] //- рабочий вариант. не удалять!
        //        animation.values = [0, Double.pi/10, 0, -(Double.pi/10), 0 ]
        //        animation.keyTimes = [NSNumber(value: 0.0),
        //                              NSNumber(value: 0.5), //0.3
        //                              NSNumber(value: 1.0)    //1.0
        
        animation.keyTimes = [NSNumber(value: 0.0),
                              NSNumber(value: 0.3),
                              NSNumber(value: 0.5),
                              NSNumber(value: 0.8), //0.3
                              NSNumber(value: 1.0)    //1.0
        ]
        stoneImageView.layer.add(animation, forKey: "rotate")
    }
 
    //MARK: OBJC methods
    @objc private func buttonPressed(sender: UIButton) {  // нажатие кнопки INFO
        print("INFO opened")
        infoViewController.modalPresentationStyle = .fullScreen
            present(infoViewController, animated: false)
    }
    @objc func makingNetworkMonitor() {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied { //&& self.infoButtonPressed == false {
                print("Internet connection - OK 24")
                self.stoneImageView.isHidden = false
            } else {
                print("There is NO internet connection 26")
                self.stoneImageView.isHidden = true
            }
        }
        let queue = DispatchQueue.main
        monitor.start(queue: queue)
    }
    @objc func refreshAction(sender: AnyObject) {  // ОБНОВЛЯЕТ данные на экране
        self.weatherManager.updateWeatherInfo(latitude: self.locationManager.location?.coordinate.latitude ?? 0.0, longtitude: self.locationManager.location?.coordinate.longitude ?? 0.0)
        { completionData in
            let temprature = completionData.temperature
            let conditionCode = completionData.id
            let windSpeed = completionData.windSpeed
            let isConnected = self.isConnected
            self.state = .init(temprature, conditionCode, windSpeed, isConnected)
        }
        print("func refreshAction done")
        refreshControl.endRefreshing()
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
                if temperature > 30 { // && windSpeed < 3.0 {
                    self = .cracks(windSpeed: windSpeed)
                    print("its cracks case!")
                } else if temperature < 30 && conditionCode >= 100 && conditionCode <= 531 { // && windSpeed < 3.0 {
                    self = .wet(windSpeed: windSpeed)
                    print("its wet case!")
                } else if temperature < 30 && conditionCode >= 600 && conditionCode <= 622 { // && windSpeed < 3.0 {
                    self = .snow(windSpeed: windSpeed)
                    print("its snow case!")
                } else if temperature < 30 && conditionCode >= 701 && conditionCode <= 781 { // && windSpeed < 3.0 {
                    self = .fog(windSpeed: windSpeed)
                    print("its fog case!")
                } else if temperature < 30 && conditionCode >= 800 && conditionCode <= 805 { // && windSpeed < 3.0 {
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
        }
        enum Borders {
            static let frameBorderColor = UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1).cgColor
            //            static let cgSizeHeight = 105
        }
        enum Colors {
            static let mainBackgroundColor = UIColor(red: 160/255, green: 160/255, blue: 160/255, alpha: 1)
            static let firstCellBackgroundColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1)
        }
    }
}
