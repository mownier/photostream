//
//  RegistrationPresenterInterface.swift
//  Photostream
//
//  Created by Mounir Ybanez on 25/10/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

protocol RegistrationPresenterInterface: class {
    
    var view: RegistrationViewInterface! { set get }
    var interactor: RegistrationInteractorInput! { set get }
    var wireframe: RegistrationWireframeInterface! { set get }
}
