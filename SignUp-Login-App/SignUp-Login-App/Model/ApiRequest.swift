//
//  ApiRequest.swift
//  SignUp-Login-App
//
//  Created by Ivan Swift on 19.05.2020.
//  Copyright © 2020 iosypenk's team. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public enum RequestType: String {
    case GET, POST
}

protocol APIRequest {
    var method: RequestType { get }
    var path: String { get }
    var parameters: [String: String] { get }
}

extension APIRequest {
    func request(with baseURL: URL, token: String?) -> URLRequest {
        guard var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false) else {
            fatalError("Unable to create URL components")
        }
        
        components.queryItems = parameters.map {
            URLQueryItem(name: String($0), value: String($1))
        }
        
        guard let url = components.url else {
            fatalError("Could not get url")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        guard let token = token else { return request }
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}

class SignUpRequest: APIRequest {
    var method: RequestType = .POST
    var path: String = "https://apiecho.cf/api/signup/"
    var parameters: [String: String]
    
    init(name: String?, mail: String?, pass: String?) {
        parameters = [:]
        guard let name = name, let mail = mail, let pass = pass else { return }
        parameters = ["name": name, "email": mail, "password": pass]
    }
}

class SignInRequest: APIRequest {
    var method: RequestType = .POST
    var path: String = "https://apiecho.cf/api/login/"
    var parameters: [String: String]

    init(mail: String?, pass: String?) {
        parameters = [:]
        guard let mail = mail, let pass = pass else { return }
        parameters = ["email": mail, "password": pass]
    }
}

class TextRequest: APIRequest {
    var method: RequestType = .GET
    var path: String = "https://apiecho.cf/api/get/text/"
    var parameters: [String: String]
    
    init() {
        parameters = [:]
    }
}
