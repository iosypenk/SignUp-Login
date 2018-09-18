//
//  Api.swift
//  SignUp-Login-App
//
//  Created by Ivan OSYPENKO on 9/18/18.
//  Copyright © 2018 iosypenk's team. All rights reserved.
//

import UIKit

struct TokenData: Decodable {
    let access_token: String
}

struct BearerToken: Decodable {
    let data : TokenData?
}

struct SignUp: Decodable {
    let name : String
    let email : String
    let password : String
}

struct Text: Decodable {
    let data : String?
}

class Api {
    
    var token : BearerToken?
    
    func signUp(name: String, mail: String, pass: String) {
        
        guard let url = URL(string: "https://apiecho.cf/api/signup/") else { return }
        
        var request = URLRequest(url: url)
        let parameters = ["name" : name, "email" : mail, "password" : pass]
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) else { return }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) {(data, response, error) in
            if let response = response {
             print(response)
             }
            guard let data = data else { return }
            do {
//                let json = try JSONSerialization.jsonObject(with: data, options: [])
                self.token = try JSONDecoder().decode(BearerToken.self, from: data)
//                print(self.token?.data?.access_token)
//                print(json)
            } catch {
                print(error)
            }
            }.resume()
    }
    
    func logIn(mail: String, pass: String, complitionHandler: @escaping (Bool, Error?) -> Void) {
        
        guard let url = URL(string: "https://apiecho.cf/api/login/") else { return }
        
        var request = URLRequest(url: url)
        let parameters = ["email" : mail, "password" : pass]
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) else { return }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            do {
                //              let json = try JSONSerialization.jsonObject(with: data, options: [])
                self.token = try JSONDecoder().decode(BearerToken.self, from: data)
                //                print(self.token!.name)
                complitionHandler(true, nil)
                print(self.token?.data?.access_token ?? "nonono")
                //                print(json)
            } catch {
                //                print(error)
                complitionHandler(false, error)
            }
            }.resume()
    }
    
    func makeTextRequest(completionHandler: @escaping (Text?, Error?) -> Void) {
        guard let newToken = self.token?.data?.access_token else {
            print("not ready")
            return
            
        }
        guard let url = URL(string: "https://apiecho.cf/api/get/text/") else { return }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.addValue("Bearer \(newToken)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        
        session.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                let jsonResponse = try JSONDecoder().decode(Text.self, from: data)
//                let json = try JSONSerialization.jsonObject(with: data, options: [])
                completionHandler(jsonResponse, nil)
            } catch {
                completionHandler(nil, error)
            }
            }.resume()
    }
}
