//
//  LoginViewController.swift
//  Photostream
//
//  Created by Mounir Ybanez on 13/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, LoginViewInterface, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    @IBInspectable var topColor: UIColor!
    @IBInspectable var bottomColor: UIColor!
    @IBInspectable var cornerRadius: CGFloat = 0

    var presenter: LoginModuleInterface!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyGradientBackground()
        applyCornerRadius()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    @IBAction func login(sender: AnyObject) {
        view.endEditing(false)
        
        loginButton.setTitle("", forState: .Normal)
        view.userInteractionEnabled = false
        addIndicatorView()
        
        let email = emailTextField.text
        let password = passwordTextField.text
        presenter.login(email, password: password)
    }

    func showLoginError(error: NSError!) {
        loginButton.setTitle("Login", forState: .Normal)
        view.userInteractionEnabled = true
        removeIndicatorView()
        
        presenter.showErrorAlert(error)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            login(loginButton)
        }
        return false
    }
    
    private func addIndicatorView() {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .White)
        indicator.startAnimating()
        indicator.tag = 9000
        loginButton.addSubviewAtCenter(indicator)
    }
    
    private func removeIndicatorView() {
        loginButton.viewWithTag(9000)?.removeFromSuperview()
    }
    
    private func applyCornerRadius() {
        emailTextField.cornerRadius = cornerRadius
        passwordTextField.cornerRadius = cornerRadius
        loginButton.cornerRadius = cornerRadius
    }
    
    private func applyGradientBackground() {
        let gradient = CAGradientLayer()
        gradient.colors = [topColor.CGColor, bottomColor.CGColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.frame = view.frame
        view.layer.insertSublayer(gradient, atIndex: 0)
    }
}
