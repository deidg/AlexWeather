//
//  SearchViewController.swift
//  AlexWeather
//
//  Created by Alex on 17.08.2023.
//

import UIKit
//import CoreLocation
import SnapKit
//import Network




//TODO: make adjustable number of lines for answers

class SearchViewController: UIViewController {
    // MARK: Elements
    weak var delegate: SearchDataDelegate?
    
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
//        defaultConfiguration()
        setupUI()
//        addTargets()
//        startLocationManager()
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
//        view.addSubview(scrollView)
//        scrollView.snp.makeConstraints { make in
//            make.edges.equalTo(view)
//        }
//
//        scrollView.addSubview(contentView)
//        contentView.snp.makeConstraints { make in
//            make.edges.equalTo(scrollView)
//        }
        
        
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
                    
   
    @objc private func sendCityName() {  // передает данные через Делагата с этого контроллера на главный через 
        if let cityName = searchTextField.text {
            delegate?.fetchSearchData(cityName)
        }
    }
}
extension SearchViewController {
    private func addTapToHideKeyboard() {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(hideKeyboard(gesture:))
        )
        contentView.addGestureRecognizer(tap)
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
    @objc private func hideKeyboard(gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}
//код из V1 reverse word - надо отрегулировать переменнные.  Код отслеживает в моменте изменение текста
extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            // Called when Return/Done is pressed on the keyboard
            textField.resignFirstResponder() // Hide the keyboard
            return true
        }
    
    
    
    
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if let text = searchTextField.text,
//           let textRange = Range(range, in: text) {
//            let updatedText = text.replacingCharacters(in: textRange, with: string)
//            if textField == reverseTextField {
//                if updatedText == "" {
//                    state = .initial
//                } else {
//                    divider.backgroundColor = Constants.Divider.dividerBackgroundColorActivated
//                    state = .typing(text: updatedText)
//                }
//            } else if textField == ignoreTextField {
//                mode = .customMode(exceptionText: updatedText)
//                state = .typing(text: reverseTextField.text ?? "")
//            }
//        }
//        return true
//    }
}
