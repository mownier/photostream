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
