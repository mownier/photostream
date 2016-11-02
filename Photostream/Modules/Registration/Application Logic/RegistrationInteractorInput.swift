//
//  RegistrationInteractorInput.swift
//  Photostream
//
//  Created by Mounir Ybanez on 05/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

protocol RegistrationInteractorInput: class {

    func register(email: String, password: String, firstName: String, lastName: String)
}
