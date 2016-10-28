//
//  RegistrationPresenterInterface.swift
//  Photostream
//
//  Created by Mounir Ybanez on 25/10/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

protocol RegistrationPresenterInterface {
    
    var view: RegistrationViewInterface! { set get }
    var interactor: RegistrationInteractorInput! { set get }
    var wireframe: RegistrationWireframeInterface! { set get }
    
    func register(email: String, password: String, firstName: String, lastName: String)
    func presentErrorAlert(message: String)
}
