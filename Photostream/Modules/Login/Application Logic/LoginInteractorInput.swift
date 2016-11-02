//
//  LoginInteractorInput.swift
//  Photostream
//
//  Created by Mounir Ybanez on 04/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

protocol LoginInteractorInput: class {

    func login(email: String, password: String)
}
