//
//  SettingsPresenter.swift
//  Photostream
//
//  Created by Mounir Ybanez on 14/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

protocol SettingsPresenterInterface: BaseModulePresenter {
    
}

class SettingsPresenter: SettingsPresenterInterface {
    
    typealias ModuleView = SettingsScene
    typealias ModuleWireframe = SettingsWireframeInterface
    
    var view: ModuleView!
    var wireframe: ModuleWireframe!
}

extension SettingsPresenter {
    
}
