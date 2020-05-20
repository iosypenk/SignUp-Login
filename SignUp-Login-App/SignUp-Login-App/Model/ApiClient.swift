//
//  Api.swift
//  SignUp-Login-App
//
//  Created by Ivan OSYPENKO on 9/18/18.
//  Copyright © 2018 iosypenk's team. All rights reserved.
//

import UIKit
import RxSwift

struct TokenData: Codable {
    let access_token: String?
}

struct ErrorObject: Codable {
    let name : String?
    let message : String?
}

struct RequestResult: Codable {
    let data : TokenData
    let errors : [ErrorObject]
    let success : Bool
}

struct Text: Codable {
    let data : String?
}


/*class Api {
    
    var result : RequestResult?
    
    func signUp(name: String, mail: String, pass: String, completionHandler: @escaping (RequestResult?, Error?) -> Void) {
        
        guard let url = URL(string: "https://apiecho.cf/api/signup/") else { return }
        
        var request = URLRequest(url: url)
        let parameters = ["name" : name, "email" : mail, "password" : pass]
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) else { return }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) {(data, response, error) in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            do {
                self.result = try JSONDecoder().decode(RequestResult.self, from: data)
                completionHandler(self.result, nil)
            } catch {
                completionHandler(nil, error)
            }
        }.resume()
    }
    
    func logIn(mail: String, pass: String, completionHandler: @escaping (RequestResult?, Error?) -> Void) {
        
        guard let url = URL(string: "https://apiecho.cf/api/login/") else { return }
        
        var request = URLRequest(url: url)
        let parameters = ["email" : mail, "password" : pass]
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) else { return }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) {(data, response, error) in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            do {
                self.result = try JSONDecoder().decode(RequestResult.self, from: data)
                completionHandler(self.result , nil)
            } catch {
                completionHandler(nil, error)
            }
        }.resume()
    }
    
    func makeTextRequest(completionHandler: @escaping (Text?, Error?) -> Void) {
        guard let newToken = self.result?.data.access_token else { return }
        guard let url = URL(string: "https://apiecho.cf/api/get/text/") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(newToken)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            do {
                let jsonResponse = try JSONDecoder().decode(Text.self, from: data)
                completionHandler(jsonResponse, nil)
            } catch {
                completionHandler(nil, error)
            }
        }.resume()
    }
}*/

class APIClient {
    private let baseURL = URL(string: "https://apiecho.cf/api/")!
    var result: RequestResult?

    func send<T: Codable>(apiRequest: APIRequest) -> Observable<T> {
        return Observable<T>.create { [unowned self] observer in
            let request = apiRequest.request(with: self.baseURL, token: self.result?.data.access_token)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                do {
                    let model: T = try JSONDecoder().decode(T.self, from: data ?? Data())
                    observer.onNext(model)
                } catch let error {
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            task.resume()

            return Disposables.create {
                task.cancel()
            }
        }
    }
}
