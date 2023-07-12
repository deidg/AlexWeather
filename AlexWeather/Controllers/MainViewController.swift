//
//  ViewController.swift
//  AlexWeather
//
//  Created by Alex on 16.05.2023.
//


//TODO: не болтается камень


import UIKit
import CoreLocation
import SnapKit
import Network

class MainViewController: UIViewController {
    //MARK: elements
    private let infoButton = InfoButton()
    private let weatherManager = WeatherManager()
    private let locationManager = CLLocationManager()
    private let refreshControl = UIRefreshControl()
    
//    private var windy: Bool = false
//    var infoButtonPressed: Bool = false
    
    private let gradientLayer = CAGradientLayer()
    private let infoButtonGradientLayer = CAGradientLayer()
    private var topColor = UIColor.orange
    private var bottomColor = UIColor.yellow
    
    private var state: State = .normal {
        didSet {
            updateWeatherState(state) <#T##windSpeed: Double##Double#>) //, windy)
        }
    }
    
    private let locationPinIcon = UIImageView(image: UIImage(named: "icon_location.png"))
    private let searchIcon = UIImageView(image: UIImage(named: "icon_search.png"))
    
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
    private let stoneImageView: UIImageView = {
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
        locationLabel.text = "anywhere"
        locationLabel.textAlignment = .center
        return locationLabel
    }()
    let infoLargeView: UIView = { // INFO view
        let infoLargeView = UIView()
        return infoLargeView
    }()
    let infoLargeViewDepth: UIView = {
        let infoLargeViewDepth = UIView()
        return infoLargeViewDepth
    }()
    let infoLargeViewTitleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    let infoLargeViewLabel: UILabel = {   //INFO view (label text)
        let label = UILabel()
        return label
    }()
    let infoButtonShadowView: UIView = {
        let infoButtonShadow = UIView()
        return infoButtonShadow
    }()
    let infoLargeViewHideButton: UIButton = {  //INFO view
        let infoLargeViewHideButton = UIButton()
        return infoLargeViewHideButton
    }()
    

    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        configureGradientLayer()
        configureInfoButtonGradientLayer()
        setupUI()
        addTargets()
        setupInfoLargeView()
        startLocationManager()
      
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
                                              longtitude: self.locationManager.location?.coordinate.longitude ?? 0.0)
        { completionData in
            let temprature = completionData.temperature
            let conditionCode = completionData.id
            let windSpeed = completionData.windSpeed
            self.state = .init(temprature, conditionCode, windSpeed)
        }
//        makingNetworkMonitor()
        print("func refreshAction done")
        refreshControl.endRefreshing()
    }
    
    // MARK: methods
    private func configureGradientLayer() {
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0,1]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.bounds
    }
    private func setupUI() {
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
//        view.addSubview(infoButtonShadowView)
        view.addSubview(infoButton)
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
        view.addSubview(infoLargeViewDepth)
        infoLargeViewDepth.snp.makeConstraints{ make in
            make.top.bottom.equalTo(view).inset(200)
            make.leading.equalTo(view).inset(80)
            make.trailing.equalTo(view).inset(40)
        }
        infoLargeViewDepth.addSubview(infoLargeView)
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
    }
    private func addTargets() {  // устанавливаем селекторы на кнопки и движения
        infoButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        infoLargeViewHideButton.addTarget(self, action: #selector(hideButtonPressed), for: .touchUpInside)
        refreshControl.addTarget(self, action: #selector(refreshAction(sender:)), for: UIControl.Event.valueChanged)
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(makingNetworkMonitor),
                             userInfo: nil, repeats: true)
    }
    
//    private func makeAttributedConditions() -> UILabel { // делает кастомный текст (атрибутивный) для condition code
//        let conditionAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.preferredFont(forTextStyle: .title2)]
//        let conditions = NSAttributedString(string: "SunnyBynny", attributes: conditionAttributes)
//
//        let attributedConditions = NSMutableAttributedString()
//        attributedConditions.append(conditions)
//
//        let label = UILabel()
//        label.attributedText = attributedConditions
//        return label
//    }
    
    private func setupInfoLargeView() {
//        let infoLargeView: UIView = { // INFO view
//            let infoLargeView = UIView()
            infoLargeView.backgroundColor = UIColor(red: 255/255, green: 128/255, blue: 0/255, alpha: 1)
            infoLargeView.isHidden = true
            infoLargeView.layer.cornerRadius = 25
            infoLargeView.layer.shadowColor = UIColor.black.cgColor
            infoLargeView.layer.shadowOpacity = 0.2 //0.5
            infoLargeView.layer.shadowOffset = CGSize(width: 0, height: 10)
            infoLargeView.layer.shadowRadius = 10
//            return infoLargeView
//        }()
//        let infoLargeViewDepth: UIView = {
//            let infoLargeViewDepth = UIView()
            infoLargeViewDepth.backgroundColor = UIColor(red: 250/255, green: 90/255, blue: 15/255, alpha: 1)
            infoLargeViewDepth.isHidden = true
            infoLargeViewDepth.layer.cornerRadius = 25
            infoLargeViewDepth.layer.shadowColor = UIColor.black.cgColor
            infoLargeViewDepth.layer.shadowOpacity = 0.2 //0.5
            infoLargeViewDepth.layer.shadowOffset = CGSize(width: 0, height: 10)
            infoLargeViewDepth.layer.shadowRadius = 10
//            return infoLargeViewDepth
//        }()
//        let infoLargeViewTitleLabel: UILabel = { //INFO view (title)
//            let label = UILabel()
        infoLargeViewTitleLabel.text = "INFO"
        infoLargeViewTitleLabel.font = UIFont.boldSystemFont(ofSize: infoLargeViewTitleLabel.font.pointSize)
        infoLargeViewTitleLabel.textAlignment = .center
//            return label
//        }()
        
//        let infoLargeViewLabel: UILabel = {   //INFO view (label text)
//            let label = UILabel()
        infoLargeViewLabel.numberOfLines = 7
        infoLargeViewLabel.textAlignment = .left
            let attributedString = NSMutableAttributedString(string: "Brick is wet - raining \nBrick is dry - sunny \nBrick is hard to see - fog \nBrick with cracks - very hot \nBrick with snow - snow \nBrick is swinging - windy \nBrick is gone - No Internet")
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 20
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        infoLargeViewLabel.attributedText = attributedString
//            return label
//        }()
//        let infoButtonShadowView: UIView = {
            let infoButtonShadow = UIView(frame: CGRect(x: 110, y: 800, width: 175, height: 85))
            infoButtonShadow.backgroundColor = UIColor.yellow
            infoButtonShadow.layer.shadowColor = UIColor.black.cgColor
            infoButtonShadow.layer.shadowOpacity = 0.2
            infoButtonShadow.layer.shadowOffset = CGSize(width: 10, height: 5)
            infoButtonShadow.layer.shadowRadius = 5
            infoButtonShadow.layer.cornerRadius = 15
//            return infoButtonShadow
//        }()
//        let infoLargeViewHideButton: UIButton = {  //INFO view
//            let infoLargeViewHideButton = UIButton()
            infoLargeViewHideButton.isEnabled = true
            infoLargeViewHideButton.setTitle("Hide", for: .normal)
            infoLargeViewHideButton.layer.borderColor = UIColor.gray.cgColor
            infoLargeViewHideButton.layer.borderWidth = 1.5
            infoLargeViewHideButton.layer.cornerRadius = 15
//            return infoLargeViewHideButton
//        }()
     
        
//        view.addSubview(infoLargeViewDepth)
//        infoLargeViewDepth.snp.makeConstraints{ make in
//            make.top.bottom.equalTo(view).inset(200)
//            make.leading.equalTo(view).inset(80)
//            make.trailing.equalTo(view).inset(40)
//        }
//        infoLargeViewDepth.addSubview(infoLargeView)
//        infoLargeView.snp.makeConstraints{ make in
//            make.centerX.equalTo(self.view)
//            make.top.bottom.equalTo(view).inset(200)
//            make.leading.trailing.equalTo(view).inset(60)
//        }
//        infoLargeView.addSubview(infoLargeViewTitleLabel)
//        infoLargeViewTitleLabel.snp.makeConstraints{ make in
//            make.centerX.equalTo(infoLargeView)
//            make.leading.trailing.equalTo(infoLargeView).inset(30)
//            make.top.equalTo(infoLargeView.snp.top).inset(30)
//        }
//        infoLargeView.addSubview(infoLargeViewLabel)
//        infoLargeViewLabel.snp.makeConstraints{ make in
//            make.centerX.equalTo(infoLargeView)
//            make.leading.trailing.equalTo(infoLargeView).inset(30)
//            make.top.equalTo(infoLargeViewTitleLabel.snp.top).inset(50)
//        }
//        infoLargeView.addSubview(infoLargeViewHideButton)
//        infoLargeViewHideButton.snp.makeConstraints{ make in
//            make.centerX.equalTo(infoLargeView)
//            make.leading.trailing.equalTo(infoLargeView).inset(30)
//            make.bottom.equalTo(infoLargeView.snp.bottom).inset(20)
//        }
        
        
    }
    
    
    
    
    @objc private func buttonPressed(sender: UIButton) {  // нажатие кнопки INFO
        print("INFO opened")
//        infoButtonPressed = true
//        makingNetworkMonitor()
        stoneImageView.isHidden = true
        infoLargeView.isHidden = false
        infoLargeViewDepth.isHidden = false
        temperatureLabel.isHidden = true
        conditionsLabel.isHidden = true
        locationLabel.isHidden = true
        locationPinIcon.isHidden = true
        searchIcon.isHidden = true
        infoButton.isHidden = true
        infoButtonShadowView.isHidden = true
    }
    @objc private func hideButtonPressed(sender: UIButton) {    // закрытие INFO
        print("closed!")
//        infoButtonPressed = false
        stoneImageView.isHidden = false
        infoLargeView.isHidden = true
        infoLargeViewDepth.isHidden = true
//        makingNetworkMonitor()
        temperatureLabel.isHidden = false
        conditionsLabel.isHidden = false
        locationLabel.isHidden = false
        locationPinIcon.isHidden = false
        searchIcon.isHidden = false
        infoButton.isHidden = false
        infoButtonShadowView.isHidden = false
    }
    
    private func updateWeatherState(_ state: State, _ windSpeed: Double) { //, _ wind: Bool) {  // регулирует состояния
        let stoneImage : UIImage?
        let alphaLevel : CGFloat
//        if wind == true {
//            switch state {
//            case .normal:
//                stoneImage = UIImage(named: "image_stone_normal.png")
//                windAnimationRotate()
//                alphaLevel = 1
//            case .wet:
//                stoneImage = UIImage(named: "image_stone_wet.png")
//                windAnimationRotate()
//                alphaLevel = 1
//            case .snow:
//                stoneImage = UIImage(named: "image_stone_snow.png")
//                windAnimationRotate()
//                alphaLevel = 1
//            case .cracks:
//                stoneImage = UIImage(named: "image_stone_cracks.png")
//                windAnimationRotate()
//                alphaLevel = 1
//            case .fog:
//                stoneImage = UIImage(named: "image_stone_normal.png")
//                windAnimationRotate()
//                alphaLevel = 0.3
//            }
//            stoneImageView.alpha = alphaLevel
//            stoneImageView.image = stoneImage
//        } else {
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
        
        if windSpeed > 3.0 {
            windAnimationRotate()
        }
        
//        }
    }
//    func checkWindSpeed(_ windSpeed: Double) {  // проверяет ветренно сегодня или нет
//        if windSpeed > 3.0 {
//            windy = true
//            print("Its windy. Answer: \(windy)")
//        } else {
//            windy = false
//            print("Its NOT windy. Answer: \(windy)")
//        }
//    }
    private func updateData(_ data: CompletionData) {
        state = .init(data.temperature, data.id, data.windSpeed)
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
    
//    private func formattingNumbers(temperatureData: String) -> NSAttributedString {
//        let degreeSign: String = "º"
//
//        let tempratureDigitsAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 64)]
//        let tempratureDegreeAttributes: [NSAttributedString.Key: Any] = [
//            .font: UIFont.boldSystemFont(ofSize:64)]
//
//        let attributedString = NSMutableAttributedString(string: temperatureData, attributes: tempratureDigitsAttributes)
//        let attributedDegree = NSAttributedString(string: degreeSign, attributes: tempratureDegreeAttributes)
//
//        attributedString.append(attributedDegree)
//        return attributedString
//    }
//    private func formattingText(discription: String) -> NSAttributedString {
//        let weatherDiscriptionAttribute: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 32)  ]
//
//        let attributedWeatherDiscription = NSMutableAttributedString(string: discription, attributes: weatherDiscriptionAttribute)
//
//        return attributedWeatherDiscription
//    }
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
    private func configureInfoButtonGradientLayer() {
        infoButtonGradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        infoButtonGradientLayer.locations = [0,1]
        infoButton.layer.addSublayer(infoButtonGradientLayer)
        infoButtonGradientLayer.frame = infoButton.bounds
    }
}

//MARK: extension
extension MainViewController {
    enum State: Equatable {
        case cracks(windspeed: Double)
        case wet(windspeed: Double)
        case snow(windspeed: Double)
        case fog(windspeed: Double)
        case normal(windspeed: Double)
//        case noInternet
        init(_ temperature: Int, _ conditionCode: Int, _ windSpeed: Double) {
            if temperature > 30 && windSpeed < 3.0 {
                self = .cracks(windspeed: windSpeed)
                print("its cracks case!")
            } else if temperature < 30 && conditionCode >= 100 && conditionCode <= 531 && windSpeed < 3.0 {
                self = .wet(windspeed: windSpeed)
                print("its wet case!")
            } else if temperature < 30 && conditionCode >= 600 && conditionCode <= 622 && windSpeed < 3.0 {
                self = .snow(windspeed: windSpeed)
                print("its snow case!")
            } else if temperature < 30 && conditionCode >= 701 && conditionCode <= 781 && windSpeed < 3.0 {
                self = .fog(windspeed: windSpeed)
                print("its fog case!")
            } else if temperature < 30 && conditionCode >= 800 && conditionCode <= 805 && windSpeed < 3.0 {
                self = .normal(windspeed: windSpeed)
                print("its normal case! And Windy")
            } else if temperature > 30 && windSpeed >= 3.0 {
                self = .cracks(windspeed: windSpeed)
                print("its cracks case! And Windy")
            } else if temperature < 30 && conditionCode >= 100 && conditionCode <= 531 && windSpeed >= 3.0 {
                self = .wet(windspeed: windSpeed)
                print("its wet case! And Windy")
            } else if temperature < 30 && conditionCode >= 600 && conditionCode <= 622 && windSpeed >= 3.0 {
                self = .snow(windspeed: windSpeed)
                print("its snow case! And Windy")
            } else if temperature < 30 && conditionCode >= 701 && conditionCode <= 781 && windSpeed >= 3.0 {
                self = .fog(windspeed: windSpeed)
                print("its fog case! And Windy!")
            } else if temperature < 30 && conditionCode >= 800 && conditionCode <= 805 && windSpeed >= 3.0 {
                self = .normal(windspeed: windSpeed)
                print("its normal case!")
            } else {
                self = .normal(windspeed: windSpeed)
                print("you§re here and conditionCode! - \(conditionCode)")
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
            
//            let attributedTemperature = self.formattingNumbers(temperatureData: temperature)
//            let attributedWeatherConditions = self.formattingText(discription: weatherConditions)
            
            DispatchQueue.main.async { [self] in
//                checkWindSpeed(windSpeedData)
                self.temperatureLabel.text = temperature + "°"
                self.conditionsLabel.text = weatherConditions
                self.locationLabel.text = city + ", " + country
                self.updateData(complitionData)
//                self.windSpeed = windSpeedData
                
                print("windspeed m/sec - \(windSpeedData)")
                scrollView.refreshControl = refreshControl
                print("response status code - \(responseStatusCode)")
            }
        }
    }
}



