//
//  RegistrationViewController.swift
//  Photostream
//
//  Created by Mounir Ybanez on 13/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    @IBInspectable var topColor: UIColor!
    @IBInspectable var bottomColor: UIColor!
    @IBInspectable var cornerRadius: CGFloat = 0

    var presenter: RegistrationModuleInterface!
    var isOkToRegister: (String, String, String, String)? {
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            let firstName = firstNameTextField.text,
            let lastName = lastNameTextField.text,
            !email.isEmpty, !password.isEmpty,
            !firstName.isEmpty, !lastName.isEmpty else {
            return nil
        }
        return (email, password, firstName, lastName)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyGradientBackground()
        applyCornerRadius()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func didTapBack() {
        (presenter as? RegistrationPresenter)?.exit()
    }
    
    fileprivate func applyCornerRadius() {
        emailTextField.cornerRadius = cornerRadius
        passwordTextField.cornerRadius = cornerRadius
        firstNameTextField.cornerRadius = cornerRadius
        lastNameTextField.cornerRadius = cornerRadius
        registerButton.cornerRadius = cornerRadius
    }
    
    fileprivate func applyGradientBackground() {
        let gradient = CAGradientLayer()
        gradient.colors = [topColor.cgColor, bottomColor.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.frame = view.frame
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    fileprivate func addIndicatorView() {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        indicator.startAnimating()
        indicator.tag = 9000
        registerButton.addSubviewAtCenter(indicator)
    }
    
    fileprivate func removeIndicatorView() {
        registerButton.viewWithTag(9000)?.removeFromSuperview()
    }
}

extension RegistrationViewController: RegistrationViewInterface {
    
    var controller: UIViewController? {
        return self
    }
    
    @IBAction func didTapRegister() {
        guard let (email, password, firstName, lastName) = isOkToRegister else {
            presenter.presentErrorAlert(message: "Fill up all the fields.")
            return
        }
        
        view.endEditing(false)
        
        registerButton.setTitle("", for: UIControlState())
        view.isUserInteractionEnabled = false
        addIndicatorView()
        
        presenter.register(email: email, password: password, firstName: firstName, lastName: lastName)
    }
    
    func didReceiveError(message: String) {
        registerButton.setTitle("Register", for: UIControlState())
        view.isUserInteractionEnabled = true
        removeIndicatorView()
        
        presenter.presentErrorAlert(message: message)
    }
    
    func didRegisterOk() {
        (presenter as? RegistrationPresenter)?.presentHome()
    }
}
