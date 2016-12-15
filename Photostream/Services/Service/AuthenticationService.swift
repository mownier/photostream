//
//  AuthenticationService.swift
//  Photostream
//
//  Created by Mounir Ybanez on 04/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

protocol AuthenticationService {

    func login(data: AuthentationServiceLoginData, callback: ((AuthenticationServiceResult) -> Void)?)
    func register(data: AuthenticationServiceRegisterData, callback: ((AuthenticationServiceResult) -> Void)?)
    func logout(callback: ((AuthenticationServiceError?) -> Void)?)
}

struct AuthentationServiceLoginData {
    
    var email: String = ""
    var password: String = ""
}

struct AuthenticationServiceRegisterData {
    
    var email: String = ""
    var password: String = ""
    var firstName: String = ""
    var lastName: String = ""
}

struct AuthenticationServiceResult {
    
    var user: User?
    var error: AuthenticationServiceError?
}

enum AuthenticationServiceError: Error {
    case authenticationNotFound(message: String)
    case authenticatedUserNotFound(message: String)
    case invalidLoginCredentials(message: String)
    case invalidRegisterCredentials(message: String)
    case unableToLogout(message: String)
    
    var message: String {
        switch self {
        case .authenticationNotFound(let message),
             .authenticatedUserNotFound(let message),
             .invalidLoginCredentials(let message),
             .invalidRegisterCredentials(let message),
             .unableToLogout(let message):
            return message
        }
    }
}
