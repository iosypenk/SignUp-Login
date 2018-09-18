//
//  ViewController.swift
//  SignUp-Login-App
//
//  Created by Ivan OSYPENKO on 9/18/18.
//  Copyright © 2018 iosypenk's team. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let api = Api()
    let textManger = TextManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        api.getBearerToken()
//        api.logIn(mail: "grateluck@gmail.com" , pass: "iosypenk")
        
        api.logIn(mail: "grateluck@gmail.com", pass: "iosypenk") { (response, error) in
            if response {
                print("token is ready")
                DispatchQueue.main.async {
                    self.api.makeTextRequest { (data, error) in
                        if let error = error {
                            print(error)
                            return
                        }
                        
                        if let str = data?.data {
                            print(str)
                            
                            self.textManger.countAlpha(text: str)
                        }
                    }
                }
               
            }
        }
        
    }


}

