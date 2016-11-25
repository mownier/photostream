//
//  LoginViewInterface.swift
//  Photostream
//
//  Created by Mounir Ybanez on 13/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

protocol LoginViewInterface: class {
    
    var controller: UIViewController? { get }
    var presenter: LoginModuleInterface! { set get }
    
    func didTapLogin()
    func didReceiveError(message: String)
    func didLoginOk()
}
