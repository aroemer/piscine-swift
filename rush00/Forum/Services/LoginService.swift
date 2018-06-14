//
//  LoginService.swift
//  Forum
//
//  Created by Alexandra Legent on 05/12/2017.
//  Copyright © 2017 Alexandre Legent. All rights reserved.
//

import UIKit

protocol LoginDelegate: class {
    func didLogin()
}

struct TokenResponse: Decodable {
    let token: String
    private enum CodingKeys: String, CodingKey {
        case token = "access_token"
    }
}

class LoginService {
    static let shared = LoginService()
    private let authUrl = "https://api.intra.42.fr/oauth/authorize?client_id=\(API_UID)&redirect_uri=forum%3A%2F%2Fauthorize&response_type=code&scope=public%20forum"
    private let tokenUrl = "https://api.intra.42.fr/oauth/token"
    private var authorization: String?
    weak var delegate: LoginDelegate?
    var token: String?
    var user: Student?
    
    var isLogin: Bool {
        return token != nil
    }
    
    func requestAuthorization() {
        guard let url = URL(string: authUrl) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func login(with url: URL) {
        guard let query = url.query else { return }
        guard let results = query.matches(pattern: "[a-z0-9]{64}") else { return }
        guard let code = results.first else { return }
        
        authorization = code
        getToken(with: code)
    }
    
    private func getToken(with code: String) {
        guard let url = URL(string: tokenUrl) else { return }
        var request = URLRequest(url: url)
        var body = "grant_type=authorization_code"
        body += "&client_id=\(API_UID)"
        body += "&client_secret=\(API_SECRET)"
        body += "&code=\(code)"
        body += "&redirect_uri=forum://authorize"
        
        request.httpMethod = "POST"
        request.httpBody = body.data(using: .utf8)
        DataService.shared.get(request: request, for: TokenResponse.self) { [unowned self] response in
            guard let response = response else { return }
            self.token = response.token
            APIService.shared.getUser(completion: { [unowned self] student in
                guard let student = student else { return }
                self.user = student
                self.delegate?.didLogin()
            })
        }
    }
}
