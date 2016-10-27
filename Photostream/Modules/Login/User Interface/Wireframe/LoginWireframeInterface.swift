//
//  LoginWireframeInterface.swift
//  Photostream
//
//  Created by Mounir Ybanez on 13/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

protocol LoginWireframeInterface {
    
    var loginPresenter: LoginPresenterInterface! { set get }
    
    init(view: LoginViewInterface)
    
    func showErrorAlert(title: String, message: String)
    func attachAsRoot(in window: UIWindow)
}
