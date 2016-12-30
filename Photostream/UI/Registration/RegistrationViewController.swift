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
    @IBOutlet weak var contentScrollView: UIScrollView!
    
    @IBInspectable var topColor: UIColor!
    @IBInspectable var bottomColor: UIColor!
    @IBInspectable var cornerRadius: CGFloat = 0

    var keyboardObserver: Any?
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
    
    deinit {
        removeKeyboardObserver()
    }
    
    override func loadView() {
        super.loadView()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTapView))
        tap.numberOfTapsRequired = 1
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyGradientBackground()
        applyCornerRadius()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        addKeyboardObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeKeyboardObserver()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func didTapBack() {
        presenter.exit()
    }
    
    func didTapView() {
        view.endEditing(true)
    }
}

extension RegistrationViewController {
    
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

extension RegistrationViewController {
    
    fileprivate func addKeyboardObserver() {
        keyboardObserver = NotificationCenter.default.addObserver(
            forName: Notification.Name.UIKeyboardWillChangeFrame,
            object: nil,
            queue: nil) { [unowned self] notif in
                self.willHandleKeyboardNotification(with: notif)
        }
    }
    
    fileprivate func removeKeyboardObserver() {
        guard keyboardObserver != nil else {
            return
        }
        
        NotificationCenter.default.removeObserver(keyboardObserver!)
    }
    
    fileprivate func willHandleKeyboardNotification(with notif: Notification) {
        var handler = KeyboardHandler()
        handler.info = notif.userInfo
        handler.willMoveUsedView = false
        
        handler.handle(using: self.contentScrollView, with: { delta in
            switch delta.direction {
            case .down:
                if delta.height == 0 {
                    self.contentScrollView.contentInset.bottom = 0
                    self.contentScrollView.scrollIndicatorInsets.bottom = 0
                    
                } else {
                    self.contentScrollView.contentInset.bottom -= abs(delta.height)
                    self.contentScrollView.scrollIndicatorInsets.bottom -= abs(delta.height)
                }
                
            case .up:
                if delta.height == 0 {
                    let rect = self.contentScrollView.convert(self.registerButton.frame, to: self.view)
                    
                    var bottom = abs(delta.y)
                    bottom -= self.view.frame.height
                    bottom += rect.maxY
                    bottom += self.emailTextField.frame.origin.y
                    
                    self.contentScrollView.contentInset.bottom = bottom
                    self.contentScrollView.scrollIndicatorInsets.bottom = abs(delta.y)
                    
                } else {
                    self.contentScrollView.contentInset.bottom += abs(delta.height)
                    self.contentScrollView.scrollIndicatorInsets.bottom += abs(delta.height)
                }
                
            default:
                break
            }
        })
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
        presenter.presentHome()
    }
}

extension RegistrationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        
        } else if textField == passwordTextField {
            firstNameTextField.becomeFirstResponder()
            
        } else if textField == firstNameTextField {
            lastNameTextField.becomeFirstResponder()
            
        } else if textField == lastNameTextField {
            didTapRegister()
            
        }
        return false
    }
}
