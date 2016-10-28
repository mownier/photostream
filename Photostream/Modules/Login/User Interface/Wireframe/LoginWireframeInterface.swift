//
//  LoginWireframeInterface.swift
//  Photostream
//
//  Created by Mounir Ybanez on 13/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

protocol LoginWireframeInterface {
    
    init(root: RootWireframeInterface?, view: LoginViewInterface)
    
    func showErrorAlert(title: String, message: String, from controller: UIViewController?)
    func attachRoot(with controller: UIViewController, in window: UIWindow)
}
