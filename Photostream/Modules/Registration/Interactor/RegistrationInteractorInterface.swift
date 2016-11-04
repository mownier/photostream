//
//  RegistrationInteractorInterface.swift
//  Photostream
//
//  Created by Mounir Ybanez on 25/10/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

protocol RegistrationInteractorInterface: class {
    
    var output: RegistrationInteractorOutput? { set get }
    var service: AuthenticationService! { set get }
    
    init(service: AuthenticationService)
}
