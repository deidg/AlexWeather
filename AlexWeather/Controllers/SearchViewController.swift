//
//  SearchViewController.swift
//  AlexWeather
//
//  Created by Alex on 17.08.2023.
//

import UIKit
import CoreLocation
import SnapKit

class SearchViewController: UIViewController {
    // MARK: Delegates
    weak var searchVCDelegate: SearchViewControllerDelegate?
    // MARK: Elements
    private var selectedCity: StackCitySearch?
    private let citySearchManager = CitySearchManager()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let backgroundView = Constants.Setup.backgroundViewImage
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
        searchTextField.leftView = Constants.Setup.searchTextFieldIndent
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
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .light, scale: .large)
        let largeCloseButton = UIImage(systemName: "xmark.circle", withConfiguration: largeConfig)
        closeButton.setImage(largeCloseButton, for: .normal)
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
            make.top.equalTo(view).inset(Constants.SetupUI.insetTop)
            make.horizontalEdges.equalTo(view).inset(Constants.SetupUI.horizontalEdges)
            make.height.equalTo(Constants.SetupUI.height)
        }
        searchView.addSubview(searchTextField)
        searchTextField.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(view).inset(Constants.SetupUI.insetTop)
            make.horizontalEdges.equalTo(view).inset(Constants.SetupUI.horizontalEdges)
            make.height.equalTo(Constants.SetupUI.height)
        }
        view.addSubview(preSelectionTableView)
        preSelectionTableView.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(searchView.snp.bottom).inset(0)
            make.horizontalEdges.equalTo(view).inset(Constants.SetupUI.horizontalEdges)
            make.bottom.equalTo(view.snp.bottom).inset(50+130)
        }
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view).inset(30)
            make.trailing.equalTo(view).inset(30)
        }
    }
    //MARK: Methods
    private func updateSearchResults(results: [StackCitySearch]) {
        searchResultArray = results
        preSelectionTableView.reloadData()
    }
    
    private func addTargets() {
        closeButton.addTarget(self, action: #selector(self.closeSearchViewController), for: .touchUpInside)
    }
    
    @objc private func closeSearchViewController(sender: UIButton) {
        dismiss(animated: true)
    }
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
}
//MARK: extensions - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = searchResultArray[indexPath.row]
        searchVCDelegate?.didSelectLocation(latitude: selectedCity.latitude, longitude: selectedCity.longitude)
        dismiss(animated: true, completion: nil)
    }
}
//MARK: extensions - UITableViewDataSource
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
// MARK: extensions - Constants
extension SearchViewController {
    enum Constants {
        enum Setup {
            static let backgroundViewImage = UIImageView(image: UIImage(named: "image_background"))
            static let searchTextFieldIndent = UIView(frame:CGRect(x:0, y:0, width:10, height:10))
            static let closeButtonImage = UIImage(systemName: "xmark.circle")
        }
        enum SetupUI {
            static let insetTop = 100
            static let horizontalEdges = 30
            static let height = 50
        }
    }
}
