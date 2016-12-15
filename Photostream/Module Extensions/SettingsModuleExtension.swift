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
    
    func presentLogout() {
        guard let presenter = self as? SettingsPresenter else {
            return
        }
        
        presenter.wireframe.showLogout(from: presenter.view.controller)
    }
}

extension SettingsWireframeInterface {
    
    func showLogout(from parent: UIViewController?) {
        let module = LogoutModule()
        module.build(root: root)
        
        var property = WireframeEntryProperty()
        property.controller = module.view.controller
        property.parent = parent
        
        module.wireframe.style = .present
        module.wireframe.enter(with: property)
    }
}
