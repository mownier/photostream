//
//  RegistrationViewInterface.swift
//  Photostream
//
//  Created by Mounir Ybanez on 13/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

protocol RegistrationViewInterface: NSObjectProtocol {
    
    var controller: UIViewController? { get }
    var presenter: RegistrationPresenterInterface! { set get }
    
    func didTapRegister()
    func didReceiveError(message: String)
    func didRegisterOk()
}
