//
//  LoginViewController.swift
//  Photostream
//
//  Created by Mounir Ybanez on 13/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, LoginViewInterface {

    var presenter: LoginModuleInterface!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func showLoginError(error: NSError!) {
        // TODO: Show UIAlertController error message
    }
}
