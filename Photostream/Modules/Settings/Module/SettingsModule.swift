//
//  SettingsModule.swift
//  Photostream
//
//  Created by Mounir Ybanez on 14/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

protocol SettingsModuleInterface: BaseModuleInterface {
    
    var sectionCount: Int { get }
    
    func sectionName(at index: Int) -> String
    func itemCount(for section: Int) -> Int
    func itemName(at index: Int, for section: Int) -> String
}

protocol SettingsModuleBuilder: BaseModuleBuilder {
    
    func build(root: RootWireframe?, sections: [SettingSection])
}

class SettingsModule: BaseModule {
    
    typealias ModuleView = SettingsScene
    typealias ModulePresenter = SettingsPresenter
    typealias ModuleWireframe = SettingsWireframe
    
    var view: ModuleView!
    var presenter: ModulePresenter!
    var wireframe: ModuleWireframe!
    
    required init(view: ModuleView) {
        self.view = view
    }
}

extension SettingsModule: SettingsModuleBuilder {
    
    func build(root: RootWireframe?) {
        presenter = SettingsPresenter()
        wireframe = SettingsWireframe(root: root)
        
        view.presenter = presenter
        
        presenter.view = view
        presenter.wireframe = wireframe
    }
    
    func build(root: RootWireframe?, sections: [SettingSection]) {
        build(root: root)
        presenter.sections.append(contentsOf: sections)
    }
}
