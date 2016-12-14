//
//  SettingsPresenter.swift
//  Photostream
//
//  Created by Mounir Ybanez on 14/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

protocol SettingsPresenterInterface: BaseModulePresenter {
    
    var sections: [SettingSection] { set get }
}

class SettingsPresenter: SettingsPresenterInterface {
    
    typealias ModuleView = SettingsScene
    typealias ModuleWireframe = SettingsWireframeInterface
    
    weak var view: ModuleView!
    
    lazy var sections = [SettingSection]()
    
    var wireframe: ModuleWireframe!
}

extension SettingsPresenter: SettingsModuleInterface {
    
    var sectionCount: Int {
        return sections.count
    }
    
    func itemCount(for section: Int) -> Int {
        guard sections.isValid(section) else {
            return 0
        }
        
        return sections[section].items.count
    }
    
    func itemName(at index: Int, for section: Int) -> String {
        guard sections.isValid(section),
            sections[section].items.isValid(index) else {
            return ""
        }
        
        return sections[section].items[index]
    }
    
    func sectionName(at index: Int) -> String {
        guard sections.isValid(index) else {
            return ""
        }
        
        return sections[index].name
    }
    
    func exit() {
        var property = WireframeExitProperty()
        property.controller = view.controller
        wireframe.exit(with: property)
    }
}
