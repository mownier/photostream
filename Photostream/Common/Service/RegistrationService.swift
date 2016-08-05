//
//  RegistrationService.swift
//  Photostream
//
//  Created by Mounir Ybanez on 05/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

typealias RegistrationServiceCallback = (User?, NSError?) -> Void

class RegistrationService: AnyObject {

    var source: RegistrationServiceSource!
    
    init(source: RegistrationServiceSource!) {
        self.source = source
    }
    
    func register(email: String!, password: String!, firstname: String!, lastname: String!, callback: RegistrationServiceCallback) {
        source.register(email, password: password, firstname: firstname, lastname: lastname) { (user, error) in
            callback(user, error)
        }
    }
}

protocol RegistrationServiceSource: class {
    
    func register(email: String!, password: String!, firstname: String!, lastname: String!, callback: RegistrationServiceCallback!)
}
