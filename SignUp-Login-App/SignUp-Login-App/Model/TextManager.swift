//
//  TextManager.swift
//  SignUp-Login-App
//
//  Created by Ivan OSYPENKO on 9/18/18.
//  Copyright © 2018 iosypenk's team. All rights reserved.
//

import UIKit

class TextManager {
    
    var charArr = [Character]()
    var dict = [Character:Int]()
    
    fileprivate func chooseAlpha(_ i: Int, _ text: String) {
        // Get UnicodeScalar.
        let u = UnicodeScalar(i)!
        
        for key in text {
            if key == Character(u) {
                if !charArr.contains(key) {
                    charArr.append(key)
                }
                if let nb = dict[key]{
                    dict[key] = nb + 1
                } else {
                    dict[key] = 1
                }
            }
        }
    }
    
    func countAlpha(text: String) {
        // ASCII values
        let min = 0
        let mid = 65
        let max = 127
        
        // Loop over all possible indexes.
        for i in mid..<max {
            chooseAlpha(i, text)
        }
        
        for i in min..<mid {
            chooseAlpha(i, text)
        }
        
        for key in charArr {
            if let count = dict[key] {
                print("\"\(key)\" - \(count) times")
            }
        }
    }
    
    
}
