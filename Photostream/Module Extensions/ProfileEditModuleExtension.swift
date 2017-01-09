//
//  ProfileEditModuleExtension.swift
//  Photostream
//
//  Created by Mounir Ybanez on 07/01/2017.
//  Copyright © 2017 Mounir Ybanez. All rights reserved.
//

extension ProfileEditModule {
    
    convenience init() {
        self.init(view: ProfileEditViewController())
    }
}

extension ProfileEditDataItem: ProfileEditHeaderViewItem {
    
    var displayNameInitial: String {
        if !username.isEmpty {
            return username[0]
        
        } else if !firstName.isEmpty {
            return firstName[0]
            
        } else {
            return "U"
        }
    }
}

extension ProfileEditDisplayItem: ProfileEditTableCellItem { }
