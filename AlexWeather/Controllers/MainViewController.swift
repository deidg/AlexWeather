//
//  ViewController.swift
//  AlexWeather
//
//  Created by Alex on 16.05.2023.
//
// TODO:  посмотреть фиолетовые предупреждения в иерархии вьюшек
// TODO: Переименовать функцию buttonPressed в более понятную.

import UIKit
import CoreLocation
import SnapKit
import Network

class MainViewController: UIViewController {
    //MARK: - elements
    //    private let infoViewController = InfoViewController()
    private let infoButton = InfoButton()
    private let weatherManager = WeatherManager()
    private let locationManager = CLLocationManager()
    
    private var networkMonitor: NWPathMonitor?
    private var isConnected: Bool = true
    
    private var isFallingAnimationActive = false
    private var isStoneFalling = false
    private var emitterLayer: CAEmitterLayer?
    
    private let refreshControl = UIRefreshControl()
    private var windSpeed: Double = 0.0
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    private var state: State = .sunny(windy: false){
        didSet {
            updateWeatherState(state, windSpeed)
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
    private var stoneImageView = UIImageView()
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
    private let infoButtonShadowView: UIView = {
        let infoButtonShadow = UIView()
        infoButtonShadow.backgroundColor = UIColor.yellow
        infoButtonShadow.layer.shadowColor = UIColor.black.cgColor
        infoButtonShadow.layer.shadowOpacity = Constants.Shadows.infoButtonShadowOpacity
        infoButtonShadow.layer.shadowOffset = CGSize(width: Constants.Shadows.infoButtonShadowOffsetWidth, height: Constants.Shadows.infoButtonShadowOffsetHeight)
        infoButtonShadow.layer.shadowRadius = Constants.Shadows.infoButtonShadowShadowRadius
        infoButtonShadow.layer.cornerRadius = Constants.Shadows.infoButtonShadowCornerRadius
        return infoButtonShadow
    }()
    
    
    private var infoView: UIView?
//    = {   // само объявление
//        var infoView = UIImageView()
////        infoView.backgroundColor = .blue // Constants.setupInfoLargeView.backgroundView
//        infoView.contentMode = .scaleAspectFill
//        //настройка тени
//
//        return infoView
//    }()
//
    
    private let infoConditionsView: UIView = {   //сам большой экран с текстом
        var infoConditionsView = UIView()
        
        infoConditionsView.backgroundColor = .blue // Constants.setupInfoLargeView.backgroundView
        infoConditionsView.contentMode = .scaleAspectFill
        //настройка тени
        infoConditionsView.backgroundColor = Constants.setupInfoView.infoLargeViewBackgroundColor
        infoConditionsView.layer.cornerRadius = Constants.setupInfoView.infoLargeViewCornerRadius
        infoConditionsView.layer.shadowColor = Constants.setupInfoView.infoLargeViewShadowColor
        infoConditionsView.layer.shadowOpacity = Constants.setupInfoView.infoLargeViewShadowOpacity
        infoConditionsView.layer.shadowOffset = CGSize(width: Constants.setupInfoView.infoLargeViewShadowOffsetWidth, height: Constants.setupInfoView.infoLargeViewShadowOffsetHeight)
        infoConditionsView.layer.shadowRadius = Constants.setupInfoView.infoLargeViewShadowRadius
        return infoConditionsView
    }()
    
    private let infoConditionsViewDepth: UIView = {
        let infoConditionsViewDepth = UIView()
        infoConditionsViewDepth.backgroundColor = Constants.setupInfoView.infoLargeViewDepthBackgroundColor
        infoConditionsViewDepth.layer.cornerRadius = Constants.setupInfoView.infoLargeViewDepthCornerRadius
        infoConditionsViewDepth.layer.shadowColor = Constants.setupInfoView.infoLargeViewDepthShadowColor
        infoConditionsViewDepth.layer.shadowOpacity = Constants.setupInfoView.infoLargeViewDepthShadowOpacity
        infoConditionsViewDepth.layer.shadowOffset = Constants.setupInfoView.infoLargeViewDepthShadowOffset
        infoConditionsViewDepth.layer.shadowRadius = Constants.setupInfoView.infoLargeViewDepthShadowRadius
        return infoConditionsViewDepth
    }()
    
    private let infoConditionsViewTitleLabel: UILabel = {
        var infoLargeViewTitleLabel = UILabel()
        infoLargeViewTitleLabel.text = Constants.setupInfoView.infoLargeViewTitleLabelText
        infoLargeViewTitleLabel.font = UIFont.boldSystemFont(ofSize: infoLargeViewTitleLabel.font.pointSize)
        infoLargeViewTitleLabel.textAlignment = .center
        return infoLargeViewTitleLabel
    }()
    
//    let attributedString: String = Constants.setupInfoLargeView.infoLargeViewLabelAttributedString

    private let infoConditionsViewMainLabel: UILabel = {
        let infoConditionsViewMainLabel = UILabel()
        infoConditionsViewMainLabel.numberOfLines = 0
        infoConditionsViewMainLabel.textAlignment = .left
        infoConditionsViewMainLabel.sizeToFit()
        return infoConditionsViewMainLabel
    }()
    
    private let infoLargeViewHideButton: UIButton = {
        let infoLargeViewHideButton = UIButton()
        infoLargeViewHideButton.isEnabled = true
        infoLargeViewHideButton.setTitle(Constants.setupInfoView.infoLargeViewHideButtonTitle, for: .normal)
        infoLargeViewHideButton.setTitleColor(Constants.setupInfoView.infoLargeViewHideButtonTitleColor, for: .normal)
        infoLargeViewHideButton.layer.borderColor = Constants.setupInfoView.infoLargeViewHideButtonBorderColor
        infoLargeViewHideButton.layer.borderWidth = Constants.setupInfoView.infoLargeViewHideButtonBorderWidth
        infoLargeViewHideButton.layer.cornerRadius = Constants.setupInfoView.infoLargeViewHideButtonCornerRaidus
        return infoLargeViewHideButton
    }()
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
//        setupInfoView()
        addTargets()
        startLocationManager()
        makingNetworkMonitor()
        makingEmitterLayer()
    }
    // MARK: - methods
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
        view.addSubview(conditionsLabel)
        conditionsLabel.snp.makeConstraints{ make in
            make.bottom.equalTo(view.snp.bottom).inset(Constants.Constraints.conditionsLabelToTop)
            make.leading.equalToSuperview().inset(Constants.Constraints.conditionsLabelBottomLeading)
            make.trailing.equalToSuperview().inset(Constants.Constraints.conditionsLabelBottomTrailing)
            make.height.equalTo(Constants.Constraints.conditionsLabelBottomHeight)
        }
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
        scrollView.refreshControl = refreshControl
        
    }
    
    private func setupInfoLargeView() {
        let attributedString = Constants.setupInfoView.infoLargeViewLabelAttributedString
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = Constants.setupInfoView.infoLargeViewLabelLineSPacing
        paragraphStyle.paragraphSpacingBefore = 5
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        infoConditionsViewMainLabel.attributedText = attributedString
    }

    private func openInfoView() { // переименовать в openInfoLargeView
        
        setupInfoLargeView()
        let initialY = screenHeight
        infoView = UIView(frame: CGRect(x: 0, y: initialY, width: screenWidth, height: screenHeight))
        //        infoView?.backgroundColor = .clear // Set the background color you want here
        //        infoView = Constants.setupInfoView.backgroundView
        self.view.addSubview(infoView ?? backgroundView)
        // Open InfoView animation
        UIView.animate(withDuration: 0.1, delay: 0, options: .allowAnimatedContent, animations: {
            self.infoView?.frame = CGRect(x: 0, y: 0, width: self.screenWidth, height: self.screenHeight)
        }, completion: nil)
        
    
        
        infoView?.addSubview(infoConditionsView)  //  основной вью для отображения текста
        infoConditionsView.snp.makeConstraints { make in
            make.top.equalTo(view).inset(Constants.Constraints.infoLargeViewTop)
            make.leading.trailing.equalTo(view).inset(Constants.Constraints.infoLargeViewLeadingTrailing)
            make.height.equalTo(Constants.Constraints.infoLargeViewHeight)
        }
        infoConditionsView.addSubview(infoConditionsViewTitleLabel)   /// лейбла для INFO
        infoConditionsViewTitleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.infoConditionsView)
            make.leading.trailing.equalTo(infoConditionsView).inset(Constants.Constraints.infoLargeViewTitleLabelLeadingTrailing)
            make.top.equalTo(infoConditionsView.snp.top).inset(Constants.Constraints.infoLargeViewTitleLabelTop)
        }
        infoConditionsView.addSubview(infoConditionsViewMainLabel)  // лейбл для текста
        infoConditionsViewMainLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.infoConditionsView)
            make.leading.trailing.equalTo(infoConditionsView).inset(Constants.Constraints.infoLargeViewLabelLeadingTrailing)
            make.top.equalTo(infoConditionsViewTitleLabel.snp.bottom).inset(Constants.Constraints.infoLargeViewLabelTop)
            make.height.equalTo(Constants.Constraints.infoLargeViewLabelHeight)
        }
        
        infoConditionsView.addSubview(infoLargeViewHideButton)
        infoLargeViewHideButton.snp.makeConstraints { make in
            make.centerX.equalTo(self.infoConditionsView)
            make.leading.trailing.equalTo(infoConditionsView).inset(Constants.Constraints.infoLargeViewHideButtonLeadingTrailing)
            make.top.equalTo(infoConditionsViewMainLabel.snp.bottom).offset(Constants.Constraints.infoLargeViewHideButtonTop)
        }
    }
    
    private func addTargets() {  // устанавливает селекторы на кнопки и движения
        infoButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        refreshControl.addTarget(self, action: #selector(refreshAction(sender:)), for: UIControl.Event.valueChanged)
        
        infoLargeViewHideButton.addTarget(self, action: #selector(infoLargeViewHideButtonPressed), for: .touchUpInside)
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
    
    private func updateWeatherState(_ state: State, _ windSpeed: Double) {
        switch state {
        case .hot(windy: let isWindy):
            if isWindy {
                windAnimationRotate()
                print("its hot case! Windy!")
                stoneImageView.image = UIImage(named: Constants.Stones.normalStoneImage)
            } else {
                print("its hot case! NOT windy!")
                stoneImageView.image = UIImage(named: Constants.Stones.normalStoneImage)
            }
        case .rain(windy: let isWindy):
            if isWindy {
                windAnimationRotate()
                print("its rain case! Windy!")
                stoneImageView.image = UIImage(named: Constants.Stones.wetStoneImage)
            } else {
                print("its rain case! NOT windy!")
                stoneImageView.image = UIImage(named: Constants.Stones.wetStoneImage)
            }
        case .snow(windy: let isWindy):
            if isWindy {
                windAnimationRotate()
                print("its snow case! Windy!")
                stoneImageView.image = UIImage(named: Constants.Stones.snowStoneImage)
            } else {
                print("its snow case! NOT windy!")
                stoneImageView.image = UIImage(named: Constants.Stones.snowStoneImage)
            }
        case .fog(windy: let isWindy):
            if isWindy {
                windAnimationRotate()
                print("its fog case! Windy!")
                stoneImageView.image = UIImage(named: Constants.Stones.normalStoneImage)
                stoneImageView.alpha = Constants.Conditions.alphaStandart
            } else {
                print("its fog case! NOT windy!")
                stoneImageView.image = UIImage(named: Constants.Stones.normalStoneImage)
                stoneImageView.alpha = Constants.Conditions.alphaStandart
            }
        case .sunny(windy: let isWindy):
            if isWindy {
                windAnimationRotate()
                print("its sunny case! Windy!")
                stoneImageView.image = UIImage(named: Constants.Stones.cracksStoneImage)
            } else {
                print("its sunny case! NOT windy!")
                stoneImageView.image = UIImage(named: Constants.Stones.cracksStoneImage)
            }
        case .normal(windy: let isWindy):
            if isWindy {
                windAnimationRotate()
                print("its normal case! Windy!")
                stoneImageView.image = UIImage(named: Constants.Stones.normalStoneImage)
            } else {
                print("its normal case! NOT windy!")
                stoneImageView.image = UIImage(named: Constants.Stones.normalStoneImage)
            }
        case .noInternet:
            stoneImageView.isHidden = true
        }
    }
    
    private func updateData(_ data: CompletionData, isConnected: Bool) {
        state = .init(temperature: data.temperature, conditionCode: data.id, windSpeed: data.windSpeed)
        print("from uppdateData")
        print(state)
    }
    //MARK: - OBJC methods
    @objc private func buttonPressed(sender: UIButton) {  // нажатие кнопки INFO
        openInfoView()
    }
    
    @objc private func infoLargeViewHideButtonPressed(sender: UIButton, view: UIView) {
        
        guard let infoView = infoView else { return } // Check if the infoView is not nil
           let initialY = screenHeight // Move the infoView above the screen
           UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: {
               infoView.frame = CGRect(x: 0, y: initialY, width: self.screenWidth, height: self.screenHeight)
           }, completion: { _ in
               // Once the animation is complete, remove the infoView from its superview
               infoView.removeFromSuperview()
               self.infoView = nil // Clear the infoView reference
           })
        
//        print("closeInfoView - done")
//        print("closeInfoView - done")
//            let initialY = screenHeight // Move the infoView above the screen
//
//        UIView.animate(withDuration: 0.1, delay: 0, options: .allowAnimatedContent, animations: { [self] in
//            self.infoView?.frame = CGRect(x: 0, y: initialY, width: self.screenWidth, height: self.screenHeight)
//            }, completion:  nil)
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
    
    @objc func refreshAction(sender: AnyObject) {  // ОБНОВЛЯЕТ данные на экране
        flash()
        makingNetworkMonitor()
        self.weatherManager.updateWeatherInfo(latitude: self.locationManager.location?.coordinate.latitude ?? 0.0, longtitude: self.locationManager.location?.coordinate.longitude ?? 0.0)
        { completionData in
            let temprature = completionData.temperature
            let conditionCode = completionData.id
            let windSpeed = completionData.windSpeed
            self.state = .init(temperature: temprature, conditionCode: conditionCode, windSpeed: windSpeed)
        }
        refreshControl.endRefreshing()
    }
    //MARK: - animation
    private func makingEmitterLayer() {
        emitterLayer = CAEmitterLayer()
        if let emitterLayer = emitterLayer {
            stoneImageView.layer.addSublayer(emitterLayer)
        }
        emitterLayer?.emitterPosition = CGPoint(x: stoneImageView.bounds.midX,
                                                y: -10)
        emitterLayer?.emitterSize = CGSize(width: stoneImageView.bounds.width,
                                           height: 0)
        emitterLayer?.emitterShape = .line
    }
    
    private func windAnimationRotate() {
        let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        animation.duration = 4
        animation.fillMode = .both
        animation.repeatCount = .infinity
        animation.values = [0, Double.pi/50, 0, -(Double.pi/50), 0]
        animation.keyTimes = [NSNumber(value: 0.0),
                              NSNumber(value: 0.3),
                              NSNumber(value: 0.5),
                              NSNumber(value: 0.8),
                              NSNumber(value: 1.0)
        ]
        stoneImageView.layer.add(animation, forKey: "rotate")
    }
    
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
    
    private func fallAnimation() {
        guard !isStoneFalling else { return }
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.duration = 3.0
        animation.repeatCount = 0.0
        animation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        animation.values = [
            NSValue(cgPoint: stoneImageView.center),
            NSValue(cgPoint: CGPoint(x: stoneImageView.center.x, y: view.bounds.height + stoneImageView.bounds.height))
        ]
        animation.keyTimes = [0, 1]
        animation.delegate = self
        stoneImageView.layer.add(animation, forKey: "fallAnimation")
        isStoneFalling = true
    }
    
    private func showStoneImage() {
        stoneImageView.isHidden = false
        isStoneFalling = false
    }
}
//MARK: - extension MainViewController
extension MainViewController {
    enum State: Equatable {
        case rain(windy: Bool)
        case sunny(windy: Bool)
        case fog(windy: Bool)
        case hot(windy: Bool)
        case snow(windy: Bool)
        case normal(windy: Bool)
        case noInternet
        
        var isWindy: Bool {
            switch self {
            case .noInternet:
                print("There is no internet")
                return false
            case .snow(let windy):
                return windy
            case .hot(let windy):
                return windy
            case .rain(let windy):
                return windy
            case .sunny(let windy):
                return windy
            case .fog(let windy):
                return windy
            case .normal(let windy):
                return windy
            }
        }
        
        init(temperature: Int, conditionCode: Int, windSpeed: Double) {
            if temperature > 30 {
                self = .hot(windy: windSpeed > Constants.Conditions.windSpeedLimit)
            } else if temperature < 30 && conditionCode >= 100 && conditionCode <= 531 {
                self = .rain(windy: windSpeed > Constants.Conditions.windSpeedLimit)
            } else if temperature < 30 && conditionCode >= 600 && conditionCode <= 622 {
                self = .snow(windy: windSpeed > Constants.Conditions.windSpeedLimit)
            } else if temperature < 30 && conditionCode >= 701 && conditionCode <= 781 {
                self = .fog(windy: windSpeed > Constants.Conditions.windSpeedLimit)
            } else if temperature < 30 && conditionCode > 800 {
                self = .normal(windy: windSpeed > Constants.Conditions.windSpeedLimit)
            } else {
                self = .normal(windy: false)
            }
        }
    }
}
//MARK: - LocationManagerDelegate
extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else { return }
        weatherManager.updateWeatherInfo(latitude: lastLocation.coordinate.latitude, longtitude: lastLocation.coordinate.longitude) { complitionData in
            let weatherConditions = complitionData.weather
            let temperature = String(complitionData.temperature)
            let city = complitionData.city
            let country = complitionData.country
            let windSpeedData = complitionData.windSpeed
            let conditionsCode = complitionData.cod
            DispatchQueue.main.async { [self] in
                self.temperatureLabel.text = temperature + "°"
                self.conditionsLabel.text = weatherConditions
                self.locationLabel.text = city + ", " + country
                self.updateData(complitionData, isConnected: isConnected)
                self.windSpeed = windSpeedData
                
                print("condtion code  - \(conditionsCode)")
                print("windspeed m/sec - \(windSpeedData)")
            }
        }
    }
}
//MARK: - CAAnimationDelegate
extension MainViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            stoneImageView.isHidden = true
        }
    }
}
//MARK: - Constants
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
            
            static let conditionsLabelToTop = 250//100
            static let conditionsLabelBottomLeading = 20
            static let conditionsLabelBottomTrailing = 100
            static let conditionsLabelBottomHeight = 50
            
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
            
            //            ======
            
            static let infoLargeViewDepthTop = 100
            static let infoLargeViewDepthLeading = 80
            static let infoLargeViewDepthTrailing = 40
            static let infoLargeViewDepthHeight = 400
            
            static let infoLargeViewTop = 100
            static let infoLargeViewLeadingTrailing = 60
            static let infoLargeViewHeight = 400
            
            static let infoLargeViewTitleLabelLeadingTrailing = 30
            static let infoLargeViewTitleLabelTop = 30
            
            static let infoLargeViewLabelLeadingTrailing = 30
            static let infoLargeViewLabelTop = 10
            static let infoLargeViewLabelHeight = 300
            
            static let infoLargeViewHideButtonLeadingTrailing = 30
            static let infoLargeViewHideButtonTop = 5
     
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
        
        //        ===========
//    TODO: убрать из названий large
        enum setupInfoView {
            static let backgroundView = UIImageView(image: UIImage(named: "image_background.png"))
            static let infoLargeViewBackgroundColor = UIColor(red: 255/255, green: 153/255, blue: 96/255, alpha: 1)
            static let infoLargeViewCornerRadius: CGFloat = 25
            static let infoLargeViewShadowColor = UIColor.black.cgColor
            static let infoLargeViewShadowOpacity: Float = 0.2
            static let infoLargeViewShadowOffsetWidth = 0
            static let infoLargeViewShadowOffsetHeight = 10
            static let infoLargeViewShadowRadius: CGFloat = 10
            
            static let infoLargeViewDepthBackgroundColor = UIColor (red: 251/255, green: 95/255, blue: 41/255, alpha: 1)
            static let infoLargeViewDepthCornerRadius: CGFloat = 25
            static let infoLargeViewDepthShadowColor = UIColor.black.cgColor
            static let infoLargeViewDepthShadowOpacity: Float = 0.2
            static let infoLargeViewDepthShadowOffset = CGSize(width: 0, height: 10)
            static let infoLargeViewDepthShadowRadius:CGFloat = 10
            
            static let infoLargeViewTitleLabelText = "INFO"
            static let infoLargeViewLabelAttributedString = NSMutableAttributedString(string: "Brick is wet - raining \nBrick is dry - sunny \nBrick is hard to see - fog \nBrick with cracks - very hot \nBrick with snow - snow \nBrick is swinging - windy \nBrick is gone - No Internet")
            static let infoLargeViewLabelNumberOfLines = 7
            static let infoLargeViewLabelLineSPacing: CGFloat = 10
            
            static let infoButtonShadowFrame = UIView(frame: CGRect(x: 110, y: 800, width: 175, height: 85))
            static let infoButtonShadowShadowOpacity: Float = 0.2
            static let infoButtonShadowShadowOffset = CGSize(width: 10, height: 5)
            static let infoButtonShadowShadowRadius: CGFloat = 5
            static let infoButtonShadowCornerRadius: CGFloat = 15
            
            static let infoLargeViewHideButtonTitle = "Hide"
            static let infoLargeViewHideButtonTitleColor = UIColor(red: 87/255, green: 87/255, blue: 87/255, alpha: 1)
            static let infoLargeViewHideButtonBorderColor = UIColor(red: 87/255, green: 87/255, blue: 87/255, alpha: 1).cgColor
            static let infoLargeViewHideButtonBorderWidth:CGFloat = 1.5
            static let infoLargeViewHideButtonCornerRaidus:CGFloat = 15
        }
    }
}




