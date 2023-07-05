//
//  ViewController.swift
//  AlexWeather
//
//  Created by Alex on 16.05.2023.
//

// TODO: разобраться почему при появлении виджета ИНФО не пропадает камень
// TODO: надпись на кнопке инфо сделать другим размером шрифта и цвет текста черный.
// TODO: добавить кнопке ИНФО тень справа
// TODO: увелчить поле отображения температуры - иногда не влезает и появляются точки

import UIKit
import CoreLocation
import SnapKit
import Network



class MainViewController: UIViewController {
    //MARK: elements
    
    let weatherManager = WeatherManager()
    
    var windSpeed: Double = 0
    var windy: Bool = false
    
    let gradientLayer = CAGradientLayer()
    
    let locationManager =  CLLocationManager()
    var currentLocation: CLLocation?
    
    var state: State = .normal {
        didSet {
            updateWeatherState(state, windy)
        }
    }
    
    let refreshControl = UIRefreshControl()
    
    private let scrollView: UIScrollView = {
        var view = UIScrollView()
        view.isScrollEnabled =  true
        view.alwaysBounceVertical = true
        return view
    }()
    private let contentView: UIView = {
        let view = UIView()
        return view
    }()
    let stoneImageView: UIImageView = {
        let stoneImageView = UIImageView()
        return stoneImageView
    }()
    let infoLargeView: UIView = { // INFO view
        let infoLargeView = UIView()
        infoLargeView.backgroundColor = UIColor(red: 255/255, green: 128/255, blue: 0/255, alpha: 1)
        infoLargeView.isHidden = true
        infoLargeView.layer.masksToBounds = true
        infoLargeView.layer.cornerRadius = 25
        return infoLargeView
    }()
    let infoLargeViewTitleLabel: UILabel = { //INFO view (title)
        let label = UILabel()
        label.text = "INFO"
        label.font =  UIFont.boldSystemFont(ofSize: label.font.pointSize)
        label.textAlignment = .center
        return label
    }()
    let infoLargeViewLabel: UILabel = {   //INFO view (label text)
        let label = UILabel()
        label.numberOfLines = 7
        label.textAlignment = .left
        let attributedString = NSMutableAttributedString(string: "Brick is wet - raining \nBrick is dry - sunny \nBrick is hard to see - fog \nBrick with cracks - very hot \nBrick with snow - snow \nBrick is swinging - windy \nBrick is gone - No Internet")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 20
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        label.attributedText = attributedString
        return label
    }()
    
    var infoLargeLabelShadowView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .yellow
        view.isHidden = true
        view.layer.cornerRadius = 25
        view.layer.masksToBounds = true

        return view
    }()
//
//    func makeShadowView() {
//
//    }
    
//    let viewShadow = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
//    viewShadow.center = self.view.center
//    viewShadow.backgroundColor = UIColor.yellow
//    viewShadow.layer.shadowColor = UIColor.red.cgColor
//    viewShadow.layer.shadowOpacity = 1
//    viewShadow.layer.shadowOffset = CGSize.zero
//    viewShadow.layer.shadowRadius = 5
//    self.view.addSubview(viewShadow)
//
    
    
    
    
    
    //TODO: make a shadow
    @objc  let infoLargeViewHideButton: UIButton = {  //INFO view
        let infoLargeViewHideButton = UIButton()
        infoLargeViewHideButton.isEnabled = true
        infoLargeViewHideButton.setTitle("Hide", for: .normal)
        infoLargeViewHideButton.layer.borderColor = UIColor.gray.cgColor
        infoLargeViewHideButton.layer.borderWidth = 1.5
        infoLargeViewHideButton.layer.cornerRadius = 15
        return infoLargeViewHideButton
    }()
    
    var topColor = UIColor.orange  // gradient
    var bottomColor = UIColor.yellow
    var temperatureLabel: UILabel = {
        let temperatureLabel = UILabel()
        temperatureLabel.textColor = .black
        temperatureLabel.textAlignment = .left
        return temperatureLabel
    }()
    let conditionsLabel: UILabel = {
        let conditionsLabel = UILabel()
        conditionsLabel.textColor = .black
        return conditionsLabel
    }()
    let locationLabel: UILabel = {
        let locationLabel = UILabel()
        locationLabel.text = "anywhere"
        locationLabel.textAlignment = .center
        return locationLabel
    }()
    @objc let infoButton: UIButton = {
        let infoButton = UIButton()
        infoButton.backgroundColor = .gray
        infoButton.setTitle("Info", for: .normal)
//        infoButton.
        infoButton.layer.cornerRadius = 15
        return infoButton
    }()
    
    let locationPinIcon = UIImageView(image: UIImage(named: "icon_location.png"))
    let searchIcon = UIImageView(image: UIImage(named: "icon_search.png"))
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        configureGradientLayer()
        setupUI()
        defaultConfiguration()
        self.refreshControl.addTarget(self, action: #selector(refreshAction(sender:)), for: UIControl.Event.valueChanged)
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(makingNetworkMonitor),
                             userInfo: nil, repeats: true)
        
        startLocationManager()
        makingNetworkMonitor()
        
        
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
    
    @objc func refreshAction(sender: AnyObject) {  // ОБНОВЛЯЕТ данные на экране
        self.weatherManager.updateWeatherInfo(latitude: self.locationManager.location?.coordinate.latitude ?? 0.0,
                                              longtitude: self.locationManager.location?.coordinate.longitude ?? 0.0) { completionData in
            let temprature = completionData.temperature
            let conditionCode = completionData.id
            let windSpeed = completionData.windSpeed
            self.state = .init(temprature, conditionCode, windSpeed)
        }
        makingNetworkMonitor()
        
        print("func refreshAction done")
        refreshControl.endRefreshing()
    }
    
    // MARK: methods
    
    func configureGradientLayer() { // делает градиентную заливку
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0,1]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.bounds
    }
    
    func setupUI() {   // раставляет все элементы на экране
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
            make.top.equalTo(contentView).offset(-160)
        }
        view.addSubview(temperatureLabel)
        temperatureLabel.snp.makeConstraints{ make in
            make.bottom.equalTo(view.snp.bottom).inset(300)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(270)
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
        view.addSubview(infoButton)
        infoButton.snp.makeConstraints{ make in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(view.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(100)
            make.height.equalTo(80)
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
        
        view.addSubview(infoLargeLabelShadowView)
        infoLargeLabelShadowView.snp.makeConstraints{ make in
            make.centerX.equalTo(self.view)
            make.top.bottom.equalTo(view).inset(200)
            make.leading.trailing.equalTo(view).inset(60)
        }
        
       
        infoLargeLabelShadowView.addSubview(infoLargeView)
        infoLargeView.snp.makeConstraints{ make in
            make.centerX.equalTo(self.view)
            make.top.bottom.equalTo(view).inset(200)
            make.leading.trailing.equalTo(view).inset(60)
        }
        
       
        infoLargeView.addSubview(infoLargeViewTitleLabel)
        infoLargeViewTitleLabel.snp.makeConstraints{ make in
            make.centerX.equalTo(self.infoLargeView)
            make.leading.trailing.equalTo(infoLargeView).inset(30)
            make.top.equalTo(infoLargeView.snp.top).inset(30)
        }
        infoLargeView.addSubview(infoLargeViewLabel)
        infoLargeViewLabel.snp.makeConstraints{ make in
            make.centerX.equalTo(self.infoLargeView)
            make.leading.trailing.equalTo(infoLargeView).inset(30)
            make.top.equalTo(infoLargeViewTitleLabel.snp.top).inset(50)
        }
        infoLargeView.addSubview(infoLargeViewHideButton)
        infoLargeViewHideButton.snp.makeConstraints{ make in
            make.centerX.equalTo(self.infoLargeView)
            make.leading.trailing.equalTo(infoLargeView).inset(30)
            make.bottom.equalTo(infoLargeView.snp.bottom).inset(20)
        }
    } // раставляет все элементы на экране
    @objc func defaultConfiguration() {  // устанавливаем селекторы на кнопки и движения
        infoButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        infoLargeViewHideButton.addTarget(self, action: #selector(hideButtonPressed), for: .touchUpInside)
    }
    
    func makeAttributedConditions() -> UILabel { // делает кастомный текст (атрибутивный) для condition code
        let conditionAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.preferredFont(forTextStyle: .title2)]//, .baselineOffset: 28]
        
        let conditions = NSAttributedString(string: "SunnyBynny", attributes: conditionAttributes)
        
        let attributedConditions = NSMutableAttributedString()
        attributedConditions.append(conditions)
        
        let label = UILabel()
        label.attributedText = attributedConditions
        return label
    }
    
    @objc private func buttonPressed(sender: UIButton) {  // нажатие кнопки INFO
        print("INFO opened")
        stoneImageView.isHidden = true
        infoLargeView.isHidden = false
        infoLargeLabelShadowView.isHidden = false
        temperatureLabel.isHidden = true
        conditionsLabel.isHidden = true
        locationLabel.isHidden = true
        locationPinIcon.isHidden = true
        searchIcon.isHidden = true
        infoButton.isHidden = true
    }
    @objc private func hideButtonPressed(sender: UIButton) {    // закрытие INFO
        print("closed!")
        stoneImageView.isHidden = false
        infoLargeView.isHidden = true
        infoLargeLabelShadowView.isHidden = true
        temperatureLabel.isHidden = false
        conditionsLabel.isHidden = false
        locationLabel.isHidden = false
        locationPinIcon.isHidden = false
        searchIcon.isHidden = false
        infoButton.isHidden = false
    }
    
    private func updateWeatherState(_ state: State, _ wind: Bool) {  // регулирует состояния
        let stoneImage : UIImage?
        let alphaLevel : CGFloat
        
        if wind == true {
            switch state {
            case .normal:
                stoneImage = UIImage(named: "image_stone_normal.png")
                windAnimationRotate()
                alphaLevel = 1
            case .wet:
                stoneImage = UIImage(named: "image_stone_wet.png")
                windAnimationRotate()
                alphaLevel = 1
            case .snow:
                stoneImage = UIImage(named: "image_stone_snow.png")
                windAnimationRotate()
                alphaLevel = 1
            case .cracks:
                stoneImage = UIImage(named: "image_stone_cracks.png")
                windAnimationRotate()
                alphaLevel = 1
            case .fog:
                stoneImage = UIImage(named: "image_stone_normal.png")
                windAnimationRotate()
                alphaLevel = 0.3
            }
            stoneImageView.alpha = alphaLevel
            stoneImageView.image = stoneImage
        } else {
            switch state {
            case .normal:
                stoneImage = UIImage(named: "image_stone_normal.png")
                alphaLevel = 1
            case .wet:
                stoneImage = UIImage(named: "image_stone_wet.png")
                alphaLevel = 1
            case .snow:
                stoneImage = UIImage(named: "image_stone_snow.png")
                alphaLevel = 1
            case .cracks:
                stoneImage = UIImage(named: "image_stone_cracks.png")
                alphaLevel = 1
            case .fog:
                stoneImage = UIImage(named: "image_stone_normal.png")
                alphaLevel = 0.3
            }
            stoneImageView.alpha = alphaLevel
            stoneImageView.image = stoneImage
        }
    }
    
    func checkWindSpeed(windSpeed: Double) {  // проверяет ветренно сегодня или нет
        if windSpeed > 3.0 {
            windy = true
            print("Its windy. Answer: \(windy)")
        } else {
            windy = false
            print("Its NOT windy. Answer: \(windy)")
        }
    }
    
    func updateData(_ data: CompletionData) {
        state = .init(data.temperature, data.id, data.windSpeed)
        print("from uppdateData")
        print(state)
    }
    func windAnimationRotate() {
        let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        animation.duration = 2
        animation.fillMode = .both
        animation.repeatCount = .infinity
        animation.values = [0, Double.pi/30, 0, -(Double.pi/30), 0 ] //- рабочий вариант. не удалять!
        //        animation.values = [0, Double.pi/10, 0, -(Double.pi/10), 0 ]
        animation.keyTimes = [NSNumber(value: 0.0),
                              NSNumber(value: 0.5), //0.3
                              NSNumber(value: 1.0)    //1.0
        ]
        stoneImageView.layer.add(animation, forKey: "rotate")
    }
    
    func formattingNumbers(temperatureData: String) -> NSAttributedString {
        let degreeSign: String = "º"
        
        let tempratureDigitsAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 64)]
        let tempratureDegreeAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize:64)]
        
        let attributedString = NSMutableAttributedString(string: temperatureData, attributes: tempratureDigitsAttributes)
        let attributedDegree = NSAttributedString(string: degreeSign, attributes: tempratureDegreeAttributes)
        
        attributedString.append(attributedDegree)
        
        return attributedString
    }
    
    func formattingText(discription: String) -> NSAttributedString {
        let weatherDiscriptionAttribute: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 32)  ]
        
        let attributedWeatherDiscription = NSMutableAttributedString(string: discription, attributes: weatherDiscriptionAttribute)
        
        return attributedWeatherDiscription
    }
    
    @objc func makingNetworkMonitor() {
        
        let monitor = NWPathMonitor()
        
        
        
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
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
    
    
    
    
    
    
}

//MARK: extension
extension MainViewController {
    
    enum State: Equatable {
        case cracks
        case wet
        case snow
        case fog
        case normal
        
        init(_ temperature: Int, _ conditionCode: Int, _ windSpeed: Double) {
            if temperature > 30 {
                self = .cracks
                print("its cracks case!")
            } else if temperature < 30 && conditionCode >= 100 && conditionCode <= 531 {
                self = .wet
                print("its wet case!")
            } else if temperature < 30 && conditionCode >= 600 && conditionCode <= 622 {
                self = .snow
                print("its snow case!")
            } else if temperature < 30 && conditionCode >= 701 && conditionCode <= 781 {
                self = .fog
                print("its fog case!")
            } else if temperature < 30 && conditionCode >= 800 && conditionCode <= 805 {
                self = .normal
                print("its normal case!")
            } else {
                self = .normal
                print("you§re here and conditionCode! - \(conditionCode)")
            }
        }
    }
}


//найти место где при отсутсвии интернета вставить исчезновение камня

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
            
            let attributedTemperature = self.formattingNumbers(temperatureData: temperature)
            let attributedWeatherConditions = self.formattingText(discription: weatherConditions)
            
            DispatchQueue.main.async { [self] in
                checkWindSpeed(windSpeed: windSpeedData)
                self.temperatureLabel.attributedText = attributedTemperature
                self.conditionsLabel.attributedText = attributedWeatherConditions
                self.locationLabel.text = city + ", " + country
                self.updateData(complitionData)
                self.windSpeed = windSpeedData
                
                
                print("windspeed m/sec - \(windSpeedData)")
                checkWindSpeed(windSpeed: windSpeedData)
                scrollView.refreshControl = refreshControl
                print("response status code - \(responseStatusCode)")
            }
        }
    }
}

