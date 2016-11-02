//
//  LoginPresenterInterface.swift
//  Photostream
//
//  Created by Mounir Ybanez on 13/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

protocol LoginPresenterInterface: class {
    
    var view: LoginViewInterface! { set get }
    var interactor: LoginInteractorInput! { set get }
    var wireframe: LoginWireframeInterface! { set get }
}
