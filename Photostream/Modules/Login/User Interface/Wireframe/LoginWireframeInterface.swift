//
//  LoginWireframeInterface.swift
//  Photostream
//
//  Created by Mounir Ybanez on 13/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

protocol LoginWireframeInterface {
    
    init(view: LoginViewInterface)
    
    var loginPresenter: LoginPresenterInterface { set get }
    
    func showErrorAlert(title: String, message: String)
    func attachAsNavigationRoot(in window: UIWindow)
}
