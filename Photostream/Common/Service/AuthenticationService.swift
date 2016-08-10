//
//  AuthenticationService.swift
//  Photostream
//
//  Created by Mounir Ybanez on 04/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

typealias AuthenticationServiceCallback = (User?, NSError?) -> Void

protocol AuthenticationService: class {

    func login(email: String!, password: String!, callback: AuthenticationServiceCallback!)
    func register(email: String!, password: String!, firstname: String!, lastname: String!, callback: AuthenticationServiceCallback!)
}
