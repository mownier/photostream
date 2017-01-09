//
//  ProfileEditDisplayItem.swift
//  Photostream
//
//  Created by Mounir Ybanez on 09/01/2017.
//  Copyright © 2017 Mounir Ybanez. All rights reserved.
//

struct ProfileEditDisplayItem {
    
    var infoLabelText: String = ""
    var infoDetailText: String = ""
    var infoEditText: String = ""
    
    mutating func clear() {
        infoLabelText = ""
        infoDetailText = ""
        infoEditText = ""
    }
}
