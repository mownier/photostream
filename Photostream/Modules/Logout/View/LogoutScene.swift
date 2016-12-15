//
//  LogoutScene.swift
//  Photostream
//
//  Created by Mounir Ybanez on 15/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

protocol LogoutScene: BaseModuleView {

    var presenter: LogoutModuleInterface! { set get }
    
    func didLogout(with error: String?)
}
