//
//  RegistrationWireframeInterface.swift
//  Photostream
//
//  Created by Mounir Ybanez on 25/10/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

protocol RegistrationWireframeInterface: class {

    var root: RootWireframeInterface? { set get }
    
    init(root: RootWireframeInterface?, view: RegistrationViewInterface)
    
    func showErrorAlert(title: String, message: String, from controller: UIViewController?)
    func attachRoot(with: UIViewController, in window: UIWindow)
}
