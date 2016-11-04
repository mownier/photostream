//
//  LoginEventHandler.swift
//  Photostream
//
//  Created by Mounir Ybanez on 02/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

protocol LoginEventHandler: class {
    
    func login(email: String, password: String)
    func presentErrorAlert(message: String)
}
