//
//  LogoutModuleExtension.swift
//  Photostream
//
//  Created by Mounir Ybanez on 15/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

extension LogoutModule {
    
    convenience init() {
        let title = "Log out"
        let message = "Are you sure that you want to log out?"
        let scene = LogoutViewController(title: title, message: message, preferredStyle: .alert)
        self.init(view: scene)
    }
}

extension LogoutModuleInterface {
    
    func presentLogin() {
        guard let presenter = self as? LogoutPresenter else {
            return
        }
        
        presenter.wireframe.showLogin()
    }
}

extension LogoutWireframeInterface {
    
    func showLogin() {
        guard root != nil else {
            return
        }
        
        let vc = LoginWireframe.createViewController()
        let loginWireframe = LoginWireframe(root: root as? RootWireframeInterface, view: vc)
        loginWireframe.attachRoot(with: vc, in: root!.window)
    }
}
