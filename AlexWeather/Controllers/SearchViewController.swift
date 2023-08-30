//
//  SearchViewController.swift
//  AlexWeather
//
//  Created by Alex on 17.08.2023.
//

import UIKit
import CoreLocation
import SnapKit
//import Network




//TODO: make adjustable number of lines for answers

class SearchViewController: UIViewController {
    // MARK: Elements
    weak var delegate: SearchDataDelegate?
    var completion: ((String) -> Void)?
    
    //    let locationManager = CLLocationManager()
    private let citySearchManager = CitySearchManager()
    private let backgroundView = UIImageView(image: UIImage(named: "image_background"))
    private let searchView: UIView = {
        let searchView = UIView()
        searchView.backgroundColor = .white
        //        searchView.alpha = 0.5
        searchView.layer.cornerRadius = 15
        return searchView
    }()
    private let searchTextField: UITextField = {
        let searchTextField = UITextField()
        searchTextField.placeholder = "Enter city name"
        searchTextField.backgroundColor = .white
        searchTextField.alpha = 0.6
        searchTextField.layer.cornerRadius = 15
        searchTextField.isEnabled = true
        searchTextField.isUserInteractionEnabled = true
        searchTextField.keyboardType = .alphabet
        //        searchTextField.becomeFirstResponder()
        return searchTextField
    }()
    
    var searchResultArray: [StackCitySearch] = []
    
    
    
    private let preSelectionTableView: UITableView = {
        let preSelectionTableView = UITableView()
        preSelectionTableView.backgroundColor = .white
        preSelectionTableView.alpha = 0.5
        preSelectionTableView.layer.cornerRadius = 15
        return preSelectionTableView
    }()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addTapToHideKeyboard()
        observeKeyboardNotificaton()
        searchTextField.delegate = self
    }
    //MARK: Items On View
    private func setupUI() {
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        view.addSubview(searchView)
        searchView.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(view).inset(100)
            make.horizontalEdges.equalTo(view).inset(30)
            make.height.equalTo(50)
        }
        searchView.addSubview(searchTextField)
        searchTextField.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(view).inset(100)
            make.horizontalEdges.equalTo(view).inset(30)
            make.height.equalTo(50)
        }
        view.addSubview(preSelectionTableView)
        preSelectionTableView.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(view).inset(100)
            make.horizontalEdges.equalTo(view).inset(30)
            make.bottom.equalTo(view.snp.bottom).inset(50+150)
        }
    }
    //MARK: Methods
    
    func updateSearchResults(results: [StackCitySearch]) {
        searchResultArray = results
        preSelectionTableView.reloadData()
    }
    
    
    //MARK: KeyboardSetup
    private func addTapToHideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    @objc private func toggleKeyboard() {
        if searchTextField.isFirstResponder {
            searchTextField.resignFirstResponder()
        } else {
            searchTextField.becomeFirstResponder()
        }
    }
    
    @objc private func hideKeyboard(gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    не работает метод. найти в старых заданиях
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           // Call endEditing whenever there's a change in the text field
           view.endEditing(true)
           return true
       }
//       func textFieldDidEndEditing(_ textField: UITextField) {
//           if let cityName = textField.text {
//               citySearchManager.searchAllCities(cityName: cityName) { [weak self] cities in
//                   DispatchQueue.main.async {
//                       self?.updateSearchResults(results: cities)
//                       print(cities)
//                   }
//               }
//           }
//       }
//
    
    
}
extension SearchViewController {
    private func observeKeyboardNotificaton() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(sender:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(sender:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    @objc private func keyboardWillShow(sender: NSNotification) {
        guard let userInfo = sender.userInfo else { return }
        guard var keyboardFrame = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else { return }
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        var contentInset: UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
    }
    @objc private func keyboardWillHide(sender: NSNotification) {
        let contentInset: UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
}

extension SearchViewController: UITextFieldDelegate {
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let cityName = textField.text {
            citySearchManager.searchAllCities(cityName: cityName) { [weak self] cities in
                DispatchQueue.main.async {
                    self?.updateSearchResults(results: cities)
                    print(cities)
                }
            }
        }
    }
    
    
    
    
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if let cityName = textField.text {
//            print("str161")
//
//            citySearchManager.searchAllCities(cityName: cityName) { [weak self] cities in
//                DispatchQueue.main.async {
//                    self?.updateSearchResults(results: cities)
//                    print("str161")
//                    print(cities)
//                }
//            }
//        }
//    }
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if let cityName = textField.text {
//            citySearchManager.searchAllCities(cityName: cityName) { [weak self] cities in
//                DispatchQueue.main.async {
//                    self?.updateSearchResults(results: cities)
//                    print(cities)
//                }
//            }
//        }
//    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if let cityName = textField.text {
//
//            citySearchManager.searchAllCities(cityName: cityName)
//
//            //                for cities in searchResultArray
//            //            {
//            //                    searchResultArray.append(<#T##newElement: String##String#>)
//            //            }
//
//            print(cityName)
//            delegate?.transferSearchData(cityName)
//        }
//        dismiss(animated: true, completion: nil)
//        return true
//    }
}

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = searchResultArray[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultArray.count
    }
}
