//
//  UserProfileExtension.swift
//  Photostream
//
//  Created by Mounir Ybanez on 25/10/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit
import FirebaseAuth

extension UserProfilePresenter {
    
    func presentLogin() {
        (interactor as? UserProfileInteractor)?.signOut()
        wireframe.navigateToLogin()
    }
}

extension UserProfileWireframe {
    
    func navigateToLogin() {
        guard let window = userProfileViewController.view.window else {
            return
        }
        let vc = LoginWireframe.createViewController()
        let wireframe = LoginWireframe(view: vc)
        wireframe.rootWireframe = rootWireframe
        wireframe.attachAsRoot(in: window)
    }
}

extension UserProfileInteractor {
    
    func signOut() {
        try? FIRAuth.auth()?.signOut()
    }
}
