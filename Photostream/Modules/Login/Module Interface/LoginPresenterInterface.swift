//
//  LoginPresenterInterface.swift
//  Photostream
//
//  Created by Mounir Ybanez on 13/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

protocol LoginPresenterInterface {
    
    weak var view: LoginViewInterface! { set get }
    var interactor: LoginInteractorInput! { set get }
    var wireframe: LoginWireframe! { set get }
    
    func login(email: String, password: String)
    func presentErrorAlert(message: String)
}
