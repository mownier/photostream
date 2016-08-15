//
//  LoginViewController.swift
//  Photostream
//
//  Created by Mounir Ybanez on 13/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, LoginViewInterface {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    @IBInspectable var topColor: UIColor!
    @IBInspectable var bottomColor: UIColor!
    @IBInspectable var cornerRadius: CGFloat = 0

    var presenter: LoginModuleInterface!

    override func viewDidLoad() {
        super.viewDidLoad()

        let gradient = CAGradientLayer()
        gradient.colors = [topColor.CGColor, bottomColor.CGColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.frame = view.frame
        view.layer.insertSublayer(gradient, atIndex: 0)

        emailTextField.cornerRadius = cornerRadius
        passwordTextField.cornerRadius = cornerRadius
        loginButton.cornerRadius = cornerRadius
    }

    @IBAction func login(sender: AnyObject) {
        let email = emailTextField.text
        let password = passwordTextField.text
        presenter.login(email, password: password)
    }

    func showLoginError(error: NSError!) {
        presenter.showErrorAlert(error)
    }
}
