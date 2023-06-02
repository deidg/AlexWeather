//
//  ViewController.swift
//  AlexWeather
//
//  Created by Alex on 16.05.2023.
//

//TODO: отображение данных и замена камня


import UIKit
import CoreLocation
import SnapKit


class MainViewController: UIViewController {
    //MARK: elements
    
    var currentWeather: CurrentWeather?
    
    var windSpeed: Double = 0
    
    var state: State = .normal { //(windy: false) {
        didSet {
            updateWeatherState(state, currentWeather: currentWeather!)
            //!!! force unwrap
        }
    }
    
  
    
    
    let refreshControl = UIRefreshControl()
    
    private let scrollView: UIScrollView = {
        var view = UIScrollView()
        //        view.backgroundColor = .yellow
        view.isScrollEnabled =  true
        view.alwaysBounceVertical = true
        return view
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    let gradientLayer = CAGradientLayer()
    var networkManager = NetworkManager()
    
    let locationManager =  CLLocationManager()
    var currentLocation: CLLocation?
    
    let infoLargeView: UIView = {
        let infoLargeView = UIView()
        infoLargeView.backgroundColor = UIColor(red: 255/255, green: 128/255, blue: 0/255, alpha: 1)
        infoLargeView.isHidden = true
        infoLargeView.layer.masksToBounds = true
        infoLargeView.layer.cornerRadius = 25
        return infoLargeView
    }()
    let infoLargeViewTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "INFO"
        label.font =  UIFont.boldSystemFont(ofSize: label.font.pointSize)
        label.textAlignment = .center
        return label
    }()
    let infoLargeViewLabel: UILabel = {
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
    @objc  let infoLargeViewHideButton: UIButton = {
        let infoLargeViewHideButton = UIButton()
        infoLargeViewHideButton.isEnabled = true
        infoLargeViewHideButton.setTitle("Hide", for: .normal)
        infoLargeViewHideButton.layer.borderColor = UIColor.gray.cgColor
        infoLargeViewHideButton.layer.borderWidth = 1.5
        infoLargeViewHideButton.layer.cornerRadius = 15
        //    infoLargeViewHideButton.titleShadowColor(for: <#T##UIControl.State#>)
        return infoLargeViewHideButton
    }()
    var topColor = UIColor.orange
    var bottomColor = UIColor.yellow
    var temperatureLabel: UILabel = {
        let temperatureLabel = UILabel()
        temperatureLabel.textColor = .black
        //        temperatureLabel.textAlignment = .left
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
    let normalStoneImageView = UIImageView(image: UIImage(named: "image_stone_normal.png"))
    
    let wetStoneImageView = UIImageView(image: UIImage(named: "image_stone_wet.png"))
    
    let snowStoneImageView = UIImageView(image: UIImage(named: "image_stone_snow.png"))
    let cracksStoneImageView = UIImageView(image: UIImage(named: "image_stone_cracks.png"))
    
    let locationPinIcon = UIImageView(image: UIImage(named: "icon_location.png"))
    let searchIcon = UIImageView(image: UIImage(named: "icon_search.png"))
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        configureGradientLayer()
        setupUI()
        defaultConfiguration()
        temperatureLabel.attributedText = makeAttributedTemprature().attributedText
        conditionsLabel.attributedText = makeAttributedConditions().attributedText
        scrollView.refreshControl = refreshControl
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        normalStoneImageView.isHidden = true
        wetStoneImageView.isHidden = true
        snowStoneImageView.isHidden = true
        cracksStoneImageView.isHidden = true
        
        
        networkManager.onComletion = { [weak self] currentWeather in
            guard let self = self else { return }
            self.updateInterfaceWith(weather: currentWeather)
            
//            print(currentWeather.temperature)
//            print(currentWeather.conditionCode)
//            print(currentWeather.conditionDescription)
//            print(currentWeather.windSpeed)
            
            //            self.updateWeatherState(conditionCode: currentWeather.conditionCode)
            
        }
        
        checkWindSpeed()
        
        self.refreshControl.addTarget(self, action: #selector(refreshAction(sender:)), for: UIControl.Event.valueChanged)
    }
    @objc func refreshAction(sender: AnyObject) {
        print("func refreshAction done")
        refreshControl.endRefreshing()
    }
    
    
    //    var windy: Bool = false
    //    var windSpeed = currentWeather?.windSpeed
    //    if windSpeed > 5.0 {
    //        windy = true
    //    } else {
    //        windy = false
    //    }
    
    func checkWindSpeed() {
        if windSpeed > 5.0 {
            windy = true
        } else {
            windy = false
        }
    }
    
    
    
    // MARK: methods
    func updateInterfaceWith(weather: CurrentWeather) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = String(format: "%.0f", weather.temperature)
            self.conditionsLabel.text = weather.conditionDescription
            
            //            self.conditionsLabel.attributedText = weather.description
            self.locationLabel.text = weather.cityName + ", " + weather.countryName
            
            let state: State = .normal //(windy: self.windSpeed > 5.0)
            self.updateWeatherState(state, currentWeather: weather)
        }
    }
    func configureGradientLayer() {
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0,1]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.bounds
    }
    func setupUI() {
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.centerX.equalTo(scrollView)
            make.top.bottom.equalTo(scrollView).offset(-60)
        }
        
        contentView.addSubview(normalStoneImageView)
        normalStoneImageView.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.trailing.leading.equalTo(contentView)
        }
        
        contentView.addSubview(wetStoneImageView)
        wetStoneImageView.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.trailing.leading.equalTo(contentView)
        }
        
        contentView.addSubview(snowStoneImageView)
        snowStoneImageView.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.trailing.leading.equalTo(contentView)
        }
        
        contentView.addSubview(cracksStoneImageView)
        cracksStoneImageView.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.trailing.leading.equalTo(contentView)
        }
        
        
        view.addSubview(temperatureLabel)
        temperatureLabel.snp.makeConstraints{ make in
            //            make.top.equalTo(theStoneImageView.snp.bottom).inset(10)
            make.bottom.equalTo(view.snp.bottom).inset(300)
            
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(270)
            make.height.equalTo(100)
        }
        view.addSubview(conditionsLabel)
        conditionsLabel.snp.makeConstraints{ make in
            //            make.top.equalTo(temperatureLabel.snp.bottom).offset(10)
            make.bottom.equalTo(view.snp.bottom).inset(250)
            
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(100)
            make.height.equalTo(50)
        }
        
        view.addSubview(locationLabel)
        locationLabel.snp.makeConstraints{ make in
            make.centerX.equalTo(self.view)
            //            make.bottom.equalTo(infoButton.snp.top).inset(50)
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
    }
    @objc func defaultConfiguration() {
        infoButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        infoLargeViewHideButton.addTarget(self, action: #selector(hideButtonPressed), for: .touchUpInside)
    }
    
    func makeAttributedTemprature() -> UILabel {
        let tempratureDigits: [NSAttributedString.Key: Any] = [.font: UIFont.preferredFont(forTextStyle: .largeTitle)]
        let tempratureDegree: [NSAttributedString.Key: Any] = [.font: UIFont.preferredFont(forTextStyle: .callout), .baselineOffset: 28]
        
        let temprature = NSAttributedString(string: "10", attributes: tempratureDigits)
        let degree = NSAttributedString(string: "°", attributes: tempratureDegree)
        
        let attributedString = NSMutableAttributedString()
        attributedString.append(temprature)
        attributedString.append(degree)
        
        let label = UILabel()
        label.attributedText = attributedString
        return label
    }
    
    func makeAttributedConditions() -> UILabel {
        let conditionAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.preferredFont(forTextStyle: .title2)]//, .baselineOffset: 28]
        
        let conditions = NSAttributedString(string: "SunnyBynny", attributes: conditionAttributes)
        
        let attributedConditions = NSMutableAttributedString()
        attributedConditions.append(conditions)
        
        let label = UILabel()
        label.attributedText = attributedConditions
        return label
    }
    
    @objc private func buttonPressed(sender: UIButton) {
        print("INFO opened")
        infoLargeView.isHidden = false
        normalStoneImageView.isHidden = true
        temperatureLabel.isHidden = true
        conditionsLabel.isHidden = true
        locationLabel.isHidden = true
        locationPinIcon.isHidden = true
        searchIcon.isHidden = true
        infoButton.isHidden = true
    }
    @objc private func hideButtonPressed(sender: UIButton) {
        print("closed!")
        infoLargeView.isHidden = true
        normalStoneImageView.isHidden = false
        temperatureLabel.isHidden = false
        conditionsLabel.isHidden = false
        locationLabel.isHidden = false
        locationPinIcon.isHidden = false
        searchIcon.isHidden = false
        infoButton.isHidden = false
    }
    @objc private func handleSwipeGesture(sender: UISwipeGestureRecognizer) {
        view.backgroundColor = .blue
    }
    
    
    private func updateWeatherState(_ state: State, currentWeather: CurrentWeather) {
        var temperature = currentWeather.temperature
        let conditionCode = 804//currentWeather.conditionCode
        var windSpeed = 6.0 //currentWeather.windSpeed
        var windy: Bool = false
        if  windSpeed > 5.0 {
            windy = true
        } else {
            windy = false
        }
        
        
        print(temperature)
        print(conditionCode)
        //                    print(currentWeather.conditionDescription)
        print(windSpeed)
        
        switch state {
        case .normal: //(var windSpeed) where windSpeed > 3://where windy == true:
            if (750...1000).contains(conditionCode) && windy == true  {
                    print("Crack situation")
                
//                cracksStoneImageView.isHidden = false
                wetStoneImageView.isHidden = false

                } else if (500...749).contains(conditionCode) {
                    print("Snow situation")
                } else if (250...499).contains(conditionCode) {
                    print("Wet situation")
                } else if (100...249).contains(conditionCode) {
                    print("Normal situation")
                }
        case .wet:
//            if conditionCode >= 250 && conditionCode <= 499 {
            if(250...499).contains(conditionCode) {
                print("Wet situation")
            }
        case .snow:
//            if conditionCode >= 500 && conditionCode <= 749 {
            if(500...749).contains(conditionCode) {
                print("Snow situation")
            }
        case .cracks:
//            if conditionCode >= 750 && conditionCode <= 1000 {
            if(750...1000).contains(conditionCode) {
                print("Crack situation")
            }
        default:
            print("Unhandled state")
        }
    }
//    var temperature = currentWeather?.temperature
//    var conditionCode = currentWeather?.conditionCode
//    var windSpeed = currentWeather?.windSpeed
    
}

var windy: Bool = false
//var state: State = .normal(windy: windy)
//updateWeatherState(state, currentWeather: CurrentWeather)

var currentWeather: CurrentWeather?

var temperature = currentWeather?.temperature
var conditionCode = currentWeather?.conditionCode
var windSpeed = currentWeather?.windSpeed

//var forecast = State(temperature, conditionCode, windSpeed)




//MARK: extension
extension MainViewController {

    enum State: Equatable {
        case normal  //(windSpeed: Double) //(windy: Bool)
        case wet  //(windSpeed: Double) //(windy: Bool)
        case snow  //(windSpeed: Double) //(windy: Bool)
        case cracks  //(windSpeed: Double) //(windy: Bool)
        case fog  //(windSpeed: Double) //(windy: Bool)
        //            case .normal(let windy):
        //                return windy
        //            case .wet(let windy):
        //                <#code#>
        //            case .snow(let windy):
        //                <#code#>
        //            case .cracks(let windy):
        //                <#code#>
        //            case .fog(let windy):
        //                <#code#>
        //            }
        //     }
        
        init(_ temperature: Double, _ conditionCode: Int, _ windSpeed: Double) {
            if temperature > 30 {
                self = .cracks //(windSpeed: windSpeed > 5)
            } else if temperature < 30 && conditionCode >= 100 && conditionCode <= 531 {
                self = .wet //(windy: windSpeed > 5)
            } else if temperature < 30 && conditionCode >= 600 && conditionCode <= 622 {
                self = .snow //(windy: windSpeed > 5)
            } else if temperature < 30 && conditionCode >= 701 && conditionCode <= 781 {
                self = .fog //(windy: windSpeed > 5)
            } else if temperature < 30 && conditionCode >= 800 && conditionCode <= 804 {
                self = .normal //(windy: windSpeed > 5)
            } else {
                self = .normal //(windy: windSpeed > 5)
            }
        }
        
    }
    
}

//MARK: LocationManagerDelegate
extension MainViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let coordinate = manager.location?.coordinate
        print("Lat - \(coordinate?.latitude ?? 0), long - \(coordinate?.longitude ?? 0)")
        networkManager.apiRequest(latitude: coordinate?.latitude ?? 0, longitude: coordinate?.longitude ?? 0)
    }
}
func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(error)
}





//130af965a13542537138a6ef5cc6216f
// 39°39′15″ с. ш. 66°57′35″ в. д.

//https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}

//        https://api.openweathermap.org/data/2.5/weather?lat=39.39&lon=66.57&appid=130af965a13542537138a6ef5cc6216f
