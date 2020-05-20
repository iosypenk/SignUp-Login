//
//  ValidatingTextField.swift
//  SignUp-Login-App
//
//  Created by Ivan Swift on 19.05.2020.
//  Copyright © 2020 iosypenk's team. All rights reserved.
//


import UIKit

class ValidatingTextField: UITextField {
  var valid: Bool = false {
    didSet {
      configureForValid()
    }
  }
  
  var hasBeenExited: Bool = false {
    didSet {
      configureForValid()
    }
  }
  
  override func resignFirstResponder() -> Bool {
    hasBeenExited = true
    return super.resignFirstResponder()
  }
  
  private func configureForValid() {
    if !valid && hasBeenExited {
      //Only color the background if the user has tried to
      //input things at least once.
        backgroundColor = .red
    } else {
      backgroundColor = .clear
    }
  }
}
