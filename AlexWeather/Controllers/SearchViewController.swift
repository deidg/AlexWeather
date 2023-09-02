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

//protocol SearchViewControllerDelegate: AnyObject {
//    func didSelectCity(cityName: String, latitude: Double, longitude: Double)
//}
    
//TODO: make adjustable number of lines for answers

class SearchViewController: UIViewController {
    
    // MARK: Elements
    weak var delegate: SearchDataDelegate?
//    weak var searchVCDelegate: SearchViewControllerDelegate?
    
    
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
        searchTextField.becomeFirstResponder()
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
//        searchVCDelegate.delegate = self
        
        preSelectionTableView.dataSource = self

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
            make.top.equalTo(searchView.snp.bottom).inset(0)
            make.horizontalEdges.equalTo(view).inset(30)
            make.bottom.equalTo(view.snp.bottom).inset(50+150)
        }
    }
    //MARK: Methods
    
    func updateSearchResults(results: [StackCitySearch]) {
        searchResultArray = results
        preSelectionTableView.reloadData()
    }
    
//    func updateSearchResults(results: [StackCitySearch]) {
//        searchResultArray = results
//        preSelectionTableView.reloadData()
//    }
    
    
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) {
            if text.isEmpty {
                // Clear the search results and reload the table view
                searchResultArray = []
                preSelectionTableView.reloadData()
            } else {
                // Search for cities as the user types
                citySearchManager.searchAllCities(cityName: text) { [weak self] cities in
                    self?.searchResultArray = cities
                    DispatchQueue.main.async {
                        self?.preSelectionTableView.reloadData()
                    }
                }
            }
        }
        return true
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = searchResultArray[indexPath.row]
        searchVCDelegate?.didSelectCity(cityName: selectedCity.name, latitude: selectedCity.latitude, longitude: selectedCity.longitude)
        dismiss(animated: true, completion: nil)
    }
    
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
//        view.endEditing(true)

    }
    @objc private func keyboardWillHide(sender: NSNotification) {
        let contentInset: UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
//        view.endEditing(true)

    }
}

extension SearchViewController: UITextFieldDelegate {
    
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
