//
//  ViewController.swift
//  SignUp-Login-App
//
//  Created by Ivan OSYPENKO on 9/18/18.
//  Copyright © 2018 iosypenk's team. All rights reserved.
//

import UIKit

class LoginVC: UIViewController, UITextFieldDelegate {

    let api = Api()
    let textManger = TextManager()
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var mailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var segmentedSwitch: UISegmentedControl!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameField.isHidden = true
        nameField.delegate = self
        mailField.delegate = self
        passwordField.delegate = self
        button.layer.cornerRadius = 7
        hideIndicator()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //Hide keyboard when user taps on return key on the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nameField.resignFirstResponder()
        mailField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let resultVC = segue.destination as? ResultVC else { return }
        resultVC.textManger = self.textManger
    }
    
    //MARK: Loading Indicator show/hide
    
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
        api.makeTextRequest { (response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print(error)
                    self.hideIndicator()
                    self.showAlert(error: "Error", message: "Connection problems")
                    return
                }
                if let response = response {
                    if let text = response.data {
                        self.textManger.countAlpha(text: text)
                        self.hideIndicator()
                        self.performSegue(withIdentifier: "showResults", sender: self)
                        self.button.isEnabled = true
                    }
                }
            }
        }
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
        api.logIn(mail: mail, pass: password, completionHandler: { (response, error) in
            DispatchQueue.main.async {
                self.checkResponse(error : error, response: response)
            }
        })
    }
    
    fileprivate func tryToRegister(_ name: String, _ mail: String, _ password: String) {
        api.signUp(name: name, mail: mail, pass: password, completionHandler: { (response, error) in
            DispatchQueue.main.async {
                self.checkResponse(error: error, response: response)
            }
        })
    }
    
    //MARK: Actions
    
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
    
    // MARK: Allert
    fileprivate func showAlert(error: String, message: String) {
        let alertController = UIAlertController(title: error, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default , handler: nil)
        
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

