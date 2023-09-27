//
//  SearchViewController.swift
//  AlexWeather
//
//  Created by Alex on 17.08.2023.
//

import UIKit
import CoreLocation
import SnapKit

protocol SearchViewControllerDelegate: AnyObject {
    func didSelectLocation(latitude: Double, longitude: Double)
}

class SearchViewController: UIViewController {
    // MARK: Delegates
    weak var searchVCDelegate: SearchViewControllerDelegate?
    // MARK: Elements
    private var selectedCity: StackCitySearch?
    private let citySearchManager = CitySearchManager()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let backgroundView = UIImageView(image: UIImage(named: "image_background"))
    private let searchView: UIView = {
        let searchView = UIView()
        searchView.backgroundColor = .white
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
        searchTextField.leftViewMode = .always
        searchTextField.leftView = UIView(frame:CGRect(x:0, y:0, width:10, height:10))
        return searchTextField
    }()
    private var searchResultArray: [StackCitySearch] = []
    private let preSelectionTableView: UITableView = {
        let preSelectionTableView = UITableView()
        preSelectionTableView.backgroundColor = .white
        preSelectionTableView.alpha = 0.5
        preSelectionTableView.layer.cornerRadius = 15
        return preSelectionTableView
    }()
    private let closeButton: UIButton = {
        let closeButton = UIButton()
        closeButton.isEnabled = true
        closeButton.tintColor = UIColor.gray
        // var.1
        closeButton.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        closeButton.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        // var.2
        //        let largeConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .light, scale: .large)
        //        let largeCloseButton = UIImage(systemName: "xmark.circle", withConfiguration: largeConfig)
        //        closeButton.setImage(largeCloseButton, for: .normal)
        
        return closeButton
    }()
    //MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addTapToHideKeyboard()
        addTargets()
        observeKeyboardNotificaton()
        searchTextField.delegate = self
        preSelectionTableView.delegate = self
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
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view).inset(30)
            make.trailing.equalTo(view).inset(30)
        }
    }
    //MARK: Methods
    func updateSearchResults(results: [StackCitySearch]) {
        searchResultArray = results
        preSelectionTableView.reloadData()
    }
    
    private func addTargets() {
        closeButton.addTarget(self, action: #selector(self.closeSearchViewController), for: .touchUpInside)
    }
    
    @objc  func closeSearchViewController(sender: UIButton) {
        dismiss(animated: true)
    }
    
//    //MARK: KeyboardSetup
//    private func addTapToHideKeyboard() {
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleKeyboard))
//        tapGesture.cancelsTouchesInView = false
//        view.addGestureRecognizer(tapGesture)
//    }
//    @objc private func toggleKeyboard() {
//        if searchTextField.isFirstResponder {
//            searchTextField.resignFirstResponder()
//        } else {
//            searchTextField.becomeFirstResponder()
//        }
//    }
//
//    @objc private func hideKeyboard(gesture: UITapGestureRecognizer) {
//        view.endEditing(true)
//    }
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        view.endEditing(true)
//    }
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        view.endEditing(true)
//    }
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if let text = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) {
//            if text.isEmpty {
//                searchResultArray = []
//                preSelectionTableView.reloadData()
//            } else {
//                citySearchManager.searchAllCities(cityName: text) { [weak self] cities in self?.searchResultArray = cities
//                    DispatchQueue.main.async {
//                        self?.preSelectionTableView.reloadData()
//                    }
//                }
//            }
//        }
//        return true
//    }
}
extension SearchViewController {
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
                searchResultArray = []
                preSelectionTableView.reloadData()
            } else {
                citySearchManager.searchAllCities(cityName: text) { [weak self] cities in self?.searchResultArray = cities
                    DispatchQueue.main.async {
                        self?.preSelectionTableView.reloadData()
                    }
                }
            }
        }
        return true
    }

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
    
}
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = searchResultArray[indexPath.row]
        searchVCDelegate?.didSelectLocation(latitude: selectedCity.latitude, longitude: selectedCity.longitude)
        dismiss(animated: true, completion: nil)
    }
}
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let citySearchResult = searchResultArray[indexPath.row]
        cell.textLabel?.text = citySearchResult.name
        cell.detailTextLabel?.text = "Country: " + citySearchResult.country
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultArray.count
    }
}
