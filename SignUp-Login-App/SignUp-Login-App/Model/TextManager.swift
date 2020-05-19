//
//  TextManager.swift
//  SignUp-Login-App
//
//  Created by Ivan OSYPENKO on 9/18/18.
//  Copyright © 2018 iosypenk's team. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class TextManager {
    static let shared = TextManager()
    private let disposeBag = DisposeBag()
    
    let charArr: BehaviorRelay<[Character]> = BehaviorRelay(value: [])
    var dict = [Character: Int]()
    
    fileprivate func chooseAlpha(_ i: Int, _ text: String) {
        // Get UnicodeScalar.
        let u = UnicodeScalar(i)!
        
        for key in text where key == Character(u) {
            if !charArr.value.contains(key) {
                let newValue = charArr.value + [key]
                charArr.accept(newValue)
            }
            if let nb = dict[key] {
                dict[key] = nb + 1
            } else {
                dict[key] = 1
            }
        }
    }
    
    func countAlpha(text: String) {
        // ASCII values
        let min = 0
        let firstUpper = 65
        let lastUpper = 90
        let firstLower = 97
        let lastLower = 122
        let firstDigit = 48
        let lastDigit = 57
        let max = 127
        
        for i in firstUpper...lastUpper {
            chooseAlpha(i, text)
        }
        
        for i in firstLower...lastLower {
            chooseAlpha(i, text)
        }
        
        for i in firstDigit...lastDigit {
            chooseAlpha(i, text)
        }
        
        // Loop over all possible indexes.
        for i in min...max {
            chooseAlpha(i, text)
        }
        
        /*for key in charArr {
            if let count = dict[key] {
                print("<\"\(key)\" - \(count) times>")
            }
        }*/
    }
}
