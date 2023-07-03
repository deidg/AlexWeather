//
//  ViewController.swift
//  AlexWeather
//
//  Created by Alex on 16.05.2023.
//

//TODO:  и замена камня,  - аттрибутивное отображение текста в лейблах (цифры, текст).
//

//https://youtu.be/zYnKdHxE7No?t=5135



import UIKit
import CoreLocation
import SnapKit


class MainViewController: UIViewController {
    //MARK: elements
    let weatherManager = WeatherManager()
    
    var windSpeed: Double = 0
    var windy: Bool = false
    
    func checkWindSpeed(windSpeed: Double) {  // проверяет ветренно сегодня или нет
        if windSpeed > 5.0 {
            windy = true
            print("Its windy 173. Answer: \(windy)")
        } else {
            windy = false
            print("Its NOT windy 176 Answer: \(windy)")
        }
        
    }
    
    
    var state: State = .normal {
        didSet {
            //            updateWeatherState(state, windy) - рабочий вариант
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
    
    let gradientLayer = CAGradientLayer()
    
    let locationManager =  CLLocationManager()
    var currentLocation: CLLocation?
    
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
    let infoLargeViewTitleLabel: UILabel = { //INFO view
        let label = UILabel()
        label.text = "INFO"
        label.font =  UIFont.boldSystemFont(ofSize: label.font.pointSize)
        label.textAlignment = .center
        return label
    }()
    let infoLargeViewLabel: UILabel = {   //INFO view
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
    //TOD): make a shadow
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
    var bottomColor = UIColor.yellow   // gradient
    var temperatureLabel: UILabel = {
        let temperatureLabel = UILabel()
        temperatureLabel.textColor = .black
        temperatureLabel.textAlignment = .left
        temperatureLabel.numberOfLines = 2
        
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
        
        
        //        temperatureLabel.attributedText = makeAttributedTemprature().attributedText
        //        conditionsLabel.attributedText = makeAttributedConditions().attributedText
        //        scrollView.refreshControl = refreshControl
        
        //        checkWindSpeed(windSpeed: windSpeed)
        
        self.refreshControl.addTarget(self, action: #selector(refreshAction(sender:)), for: UIControl.Event.valueChanged)
        
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
                                              longtitude: self.locationManager.location?.coordinate.longitude ?? 0.0) { completionData in
            let temprature = completionData.temperature
            let conditionCode = completionData.id
            let windSpeed = completionData.windSpeed
            
            self.state = .init(temprature, conditionCode, windSpeed)
        }
        
        print("func refreshAction done")
        refreshControl.endRefreshing()
    }
    
    //    func checkWindSpeed(windSpeed: Double) {  // проверяет ветренно сегодня или нет
    //        if windSpeed > 5.0 {
    //            windy = true
    //            print("Its windy 173. Answer: \(windy)")
    //        } else {
    //            windy = false
    //            print("Its NOT windy 176 Answer: \(windy)")
    //        }
    //
    //    }
    
    // MARK: methods
    
    func configureGradientLayer() { // делает градиентную заливку
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0,1]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.bounds
    } // делает градиентную заливку
    
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
            make.bottom.equalTo(view.snp.bottom).offset(15) //усаживает кнопку на глубину
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
        
        view.addSubview(infoLargeView)
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
    } // устанавливаем селекторы на кнопки и движения
    
    //    func makeAttributedTemprature() -> UILabel {  // делает кастомный текст (атрибутивный) для температуры
    //        let tempratureDigits: [NSAttributedString.Key: Any] = [.font: UIFont.preferredFont(forTextStyle: .title3)]
    //        let tempratureDegree: [NSAttributedString.Key: Any] = [.font: UIFont.preferredFont(forTextStyle: .callout), .baselineOffset: 28]
    //        let temprature = NSAttributedString(string: "10", attributes: tempratureDigits)
    //        let degree = NSAttributedString(string: "°", attributes: tempratureDegree)
    //        let attributedString = NSMutableAttributedString()
    //        attributedString.append(temprature)
    //        attributedString.append(degree)
    //
    //        let label = UILabel()
    //        label.attributedText = attributedString
    //        return label
    //    } // делает кастом
    
    
    
    
    //    func makeAttributedTemprature(temp: String) -> UILabel {  // делает кастомный текст (атрибутивный) для температуры
    //        let tempratureDigits: [NSAttributedString.Key: Any] = [.font: UIFont.preferredFont(forTextStyle: .title3)]
    //        let tempratureDegree: [NSAttributedString.Key: Any] = [.font: UIFont.preferredFont(forTextStyle: .callout), .baselineOffset: 28]
    //        let temprature = NSAttributedString(string: temp, attributes: tempratureDigits)
    //        let degree = NSAttributedString(string: "°", attributes: tempratureDegree)
    ////        let attributedString = NSMutableAttributedString()
    ////        attributedString.append(temprature)
    ////        attributedString.append(degree)
    ////
    ////        let label = UILabel()
    ////        label.attributedText = attributedString
    //        return label
    //
    //    } // делает кастомный текст (атрибутивный) для температуры
    
    
    
    
    
    
    func makeAttributedConditions() -> UILabel { // делает кастомный текст (атрибутивный) для condition code
        let conditionAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.preferredFont(forTextStyle: .title2)]//, .baselineOffset: 28]
        
        let conditions = NSAttributedString(string: "SunnyBynny", attributes: conditionAttributes)
        
        let attributedConditions = NSMutableAttributedString()
        attributedConditions.append(conditions)
        
        let label = UILabel()
        label.attributedText = attributedConditions
        return label
    } // делает кастомный текст (атрибутивный) для condition code
    
    @objc private func buttonPressed(sender: UIButton) {  // нажатие кнопки INFO
        print("INFO opened")
        stoneImageView.isHidden = true
        infoLargeView.isHidden = false
        temperatureLabel.isHidden = true
        conditionsLabel.isHidden = true
        locationLabel.isHidden = true
        locationPinIcon.isHidden = true
        searchIcon.isHidden = true
        infoButton.isHidden = true
    }  // нажатие кнопки INFO
    @objc private func hideButtonPressed(sender: UIButton) {    // закрытие INFO
        print("closed!")
        stoneImageView.isHidden = false
        infoLargeView.isHidden = true
        temperatureLabel.isHidden = false
        conditionsLabel.isHidden = false
        locationLabel.isHidden = false
        locationPinIcon.isHidden = false
        searchIcon.isHidden = false
        infoButton.isHidden = false
    }  // закрытие INFO
    
    private func updateWeatherState(_ state: State, _ wind: Bool) {  // регулирует состояния
        let stoneImage : UIImage?
        let alphaLevel : CGFloat
        
        if wind == true {    //         if windy == true { рабочий вариант
            
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
            
            let attributedTemperature = self.formattingNumbers(temperatureData: temperature)
            let attributedWeatherConditions = self.formattingText(discription: weatherConditions)
            
            DispatchQueue.main.async { [self] in
          
                self.temperatureLabel.attributedText = attributedTemperature //temperature //String(format: "%.0f", temprature)
                
                self.conditionsLabel.attributedText = attributedWeatherConditions
                
                self.locationLabel.text = city + ", " + country
                
                self.updateData(complitionData)
                
                self.windSpeed = windSpeedData
                print("windspeedKm  468 - \(windSpeedData)")
                checkWindSpeed(windSpeed: windSpeedData)

                scrollView.refreshControl = refreshControl
            }
        }
    }
    
}



