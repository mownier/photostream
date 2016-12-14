//
//  SettingsModuleExtension.swift
//  Photostream
//
//  Created by Mounir Ybanez on 14/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit
import FirebaseAuth

extension SettingsModule {
    
    convenience init() {
        self.init(view: SettingsViewController())
    }
}

extension SettingsModuleInterface {
    
    func presentLogin() {
        guard let presenter = self as? SettingsPresenter else {
            return
        }
        
        try? FIRAuth.auth()?.signOut()
        
        presenter.wireframe.showLogin()
    }
}

extension SettingsWireframeInterface {
    
    func showLogin() {
        guard root != nil else {
            return
        }
        
        let vc = LoginWireframe.createViewController()
        let loginWireframe = LoginWireframe(root: root as? RootWireframeInterface, view: vc)
        loginWireframe.attachRoot(with: vc, in: root!.window)
    }
}
