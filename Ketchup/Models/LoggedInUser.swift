//
//  LoggedInUser.swift
//  Ketchup
//
//  Created by Brian Dorfman on 3/10/18.
//  Copyright © 2018 Ketchup. All rights reserved.
//

import Foundation
import ObjectMapper
import Locksmith
import Alamofire

typealias CompletionBlockWithSuccess = (_ success: Bool) -> ()

class LoggedInUser: Mappable {
    static let currentUserChangedNotificationKey = Notification.Name("CurrentUserChangedNotificationKey")
    
    static var current: LoggedInUser? {
        didSet {
            NotificationCenter.default.post(name: currentUserChangedNotificationKey,
                                            object: nil)
        }
    }
    
    static let KeychainAccountKey = "Ketchup"
    
    var id: String!
    var email: String!
    var authToken: String!
    var isLoggedIn: Bool {
        get {
            return LoggedInUser.current?.email == self.email
        }
    }
    
    let requiredKeys = ["id", "auth_token", "email"]
    var sessionManager: SessionManager!
    
    required init?(map: Map) {
        for key in requiredKeys {
            if map.JSON[key] == nil {
                return nil
            }
        }
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        authToken <- map["auth_token"]
        email <- map["email"]
    }
    
    static func loginFromKeychain(onCompletion: @escaping CompletionBlockWithSuccess) {
        guard let keychainData = Locksmith.loadDataForUserAccount(userAccount: KeychainAccountKey),
            let email = keychainData["email"] as? String,
            let password = keychainData["password"] as? String else {
                onCompletion(false)
                return
        }
        
        login(email: email, password: password, onCompletion: onCompletion)
    }
    
    private enum LoginOrSignup {
        case login
        case signup
        
        var url: String { get {
            switch self {
            case .login:
                return "https://ketchupapp.co/users/sign_in"
            case .signup:
                return "https://ketchupapp.co/users"
            }
            }}
    }
    
    private static func loginOrSignup(_ method: LoginOrSignup, email: String, password: String, onCompletion: @escaping CompletionBlockWithSuccess) {
        LoggedInUser.current?.logout()
        
        let urlString =  method.url
        let emailPasswordDictionary = ["email": email, "password": password ]
        let parameters = ["user": emailPasswordDictionary]
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept": "application/json"
        ]
        Alamofire.request(urlString,
                          method: .post,
                          parameters: parameters,
                          encoding: JSONEncoding.default,
                          headers: headers)
        Alamofire.request(urlString).responseObject { (response: DataResponse<LoggedInUser>) in
            guard let user = response.result.value else {
                onCompletion(false)
                return
            }
            try? Locksmith.saveData(data: emailPasswordDictionary, forUserAccount: KeychainAccountKey)
            
            var headers = Alamofire.SessionManager.defaultHTTPHeaders
            headers["X-User-Email"] = user.email
            headers["X-User-Token"] = user.authToken
            headers["Accept"] = "application/json"
            let configuration = URLSessionConfiguration.default
            configuration.httpAdditionalHeaders = headers
            user.sessionManager = Alamofire.SessionManager(configuration: configuration)
            LoggedInUser.current = user
            onCompletion(true)
        }
    }
    
    static func signup(email: String, password: String, onCompletion: @escaping CompletionBlockWithSuccess) {
        loginOrSignup(.signup, email: email, password: password, onCompletion: onCompletion)
    }
    
    static func login(email: String, password: String, onCompletion: @escaping CompletionBlockWithSuccess) {
        loginOrSignup(.login, email: email, password: password, onCompletion: onCompletion)
    }
    
    func logout() {
        try? Locksmith.deleteDataForUserAccount(userAccount: LoggedInUser.KeychainAccountKey)
        LoggedInUser.current = nil
    }
}
