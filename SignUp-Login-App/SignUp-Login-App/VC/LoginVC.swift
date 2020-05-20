//
//  ViewController.swift
//  SignUp-Login-App
//
//  Created by Ivan OSYPENKO on 9/18/18.
//  Copyright © 2018 iosypenk's team. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginVC: UIViewController, UITextFieldDelegate {

    private let api = APIClient()
    private let disposeBag = DisposeBag()
    
    @IBOutlet private weak var nameField: ValidatingTextField!
    @IBOutlet private weak var mailField: ValidatingTextField!
    @IBOutlet private weak var passwordField: ValidatingTextField!
    @IBOutlet private weak var button: UIButton!
    @IBOutlet private weak var segmentedSwitch: UISegmentedControl!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameField.isHidden = true
        nameField.delegate = self
        mailField.delegate = self
        passwordField.delegate = self
        mailField.text = "rx@rx.com"
        passwordField.text = "123456"
        button.layer.cornerRadius = 7
        hideIndicator()
        
        setupTextChangeHandling()
        setupTapHandling()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
//
//    // Hide keyboard when user taps on return key on the keyboard
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        self.view.endEditing(true)
//        return false
//    }
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        nameField.resignFirstResponder()
//        mailField.resignFirstResponder()
//        passwordField.resignFirstResponder()
//    }
}

// MARK: - Rx setup
extension LoginVC {
    func setupTapHandling() {
        button.rx.tap.asObservable()
            .map { [unowned self] in
                SignInRequest(mail: self.mailField.text, pass: self.passwordField.text)
        }.flatMapLatest { request -> Observable<RequestResult> in
            return self.api.send(apiRequest: request)
        }.do(onNext: { [unowned self] result in
            self.api.result = result
        })
    }
    
func setupTextChangeHandling() {
    let nameIsValid = nameField
        .rx
        .text
        .observeOn(MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .throttle(.milliseconds(100), scheduler: MainScheduler.instance)
            .map { [unowned self] in
                self.validateName(text: $0)
        }
        
        nameIsValid
            .subscribe(onNext: { [unowned self] in
                self.nameField.valid = $0
            })
            .disposed(by: disposeBag)
        
        let mailIsValid = mailField
            .rx
            .text
            .observeOn(MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .throttle(.milliseconds(100), scheduler: MainScheduler.instance)
            .map { [unowned self] in
                self.validateMail(text: $0)
        }
        
        mailIsValid
            .subscribe(onNext: { [unowned self] in
                self.mailField.valid = $0
            })
            .disposed(by: disposeBag)
        
        let passwordIsValid = passwordField
            .rx
            .text
            .observeOn(MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .throttle(.milliseconds(100), scheduler: MainScheduler.instance)
            .map { [unowned self] in
                self.validatePassword(text: $0)
        }
        
        passwordIsValid
            .subscribe(onNext: { [unowned self] in
                self.passwordField.valid = $0
            })
            .disposed(by: disposeBag)
        
        let everythingValid = Observable
            .combineLatest(nameIsValid, mailIsValid, passwordIsValid) { [unowned self] in
                (self.segmentedSwitch.selectedSegmentIndex == 0 || $0) && $1 && $2
        }
        
        everythingValid
            .bind(to: button.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}

//MARK: - Validation methods
private extension LoginVC {
    func validateName(text: String?) -> Bool {
        guard let text = text, text.count > 1  else { return false }
        return true
    }
    
    func validateMail(text: String?) -> Bool {
        guard let text = text else { return false }
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: text, options: [], range: NSRange(location: 0, length: text.count)) != nil
    }
    
    func validatePassword(text: String?) -> Bool {
        guard let text = text, text.count > 5 else { return false }
        return true
    }
}

extension LoginVC {
    private func showIndicator() {
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
    }
    
    private func hideIndicator() {
        loadingIndicator.isHidden = true
        loadingIndicator.stopAnimating()
    }
    
    //MARK: GET request for text
    
    private func makeTextRequest() {
        showIndicator()
//        api.makeTextRequest { (response, error) in
//            DispatchQueue.main.async {
//                if let error = error {
//                    print(error)
//                    self.hideIndicator()
//                    self.button.isEnabled = true
//                    self.showAlert(error: "Error", message: "Connection problems")
//                    return
//                }
//                if let response = response {
//                    if let text = response.data {
//                        TextManager.shared.countAlpha(text: text)
//                        self.hideIndicator()
//                        self.performSegue(withIdentifier: "showResults", sender: self)
//                        self.button.isEnabled = true
//                    }
//                }
//            }
//        }
    }
    
    fileprivate func checkResponse(error: Error?, response : RequestResult?) {
        if let error = error {
            print(error)
            self.button.isEnabled = true
            self.showAlert(error: "Error", message: "Connection problems")
            return
        }
        
        if let newResponse = response {
            if newResponse.success {
                self.makeTextRequest()
            } else {
                self.button.isEnabled = true
                for key in newResponse.errors {
                    guard let name = key.name else { continue }
                    if let message = key.message {
                        showAlert(error: "Wrong \(name)", message: message)
                    }
                }
            }
        }
    }
    
    //MARK: POST requests for token
    
    fileprivate func tryToLogin(_ mail: String, _ password: String) {
//        api.logIn(mail: mail, pass: password, completionHandler: { (response, error) in
//            DispatchQueue.main.async {
//                self.checkResponse(error : error, response: response)
//            }
//        })
    }
    
    fileprivate func tryToRegister(_ name: String, _ mail: String, _ password: String) {
//        api.signUp(name: name, mail: mail, pass: password, completionHandler: { (response, error) in
//            DispatchQueue.main.async {
//                self.checkResponse(error: error, response: response)
//            }
//        })
    }
    
    // MARK: Actions
    @IBAction func signUpSwitch(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            nameField.isHidden = true
            button.setTitle("SignIn", for: .normal)
        case 1:
            nameField.isHidden = false
            button.setTitle("SignUp", for: .normal)
        default:
            break
        }
        
    }
    
    @IBAction func buttonTaped(_ sender: UIButton) {
        guard let mail = mailField.text else { return }
        guard let password = passwordField.text else { return }
        
        //protection against multiple segues
        button.isEnabled = false
        
        if segmentedSwitch.selectedSegmentIndex == 0 {
            tryToLogin(mail, password)
        } else if segmentedSwitch.selectedSegmentIndex == 1 {
            guard let name = nameField.text else { return }
            tryToRegister(name, mail, password)
        }
    }
    
    // MARK: Alert
    private func showAlert(error: String, message: String) {
        let alertController = UIAlertController(title: error, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default , handler: nil)
        
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

