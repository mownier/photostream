//
//  LoginInteractorInterface.swift
//  Photostream
//
//  Created by Mounir Ybanez on 27/10/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

protocol LoginInteractorInterface: class {

    var service: AuthenticationService! { set get }
    var output: LoginInteractorOutput? { set get }
    
    init(service: AuthenticationService)
}
