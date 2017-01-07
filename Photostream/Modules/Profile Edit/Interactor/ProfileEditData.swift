//
//  ProfileEditData.swift
//  Photostream
//
//  Created by Mounir Ybanez on 07/01/2017.
//  Copyright © 2017 Mounir Ybanez. All rights reserved.
//

protocol ProfileEditData {

    var username: String { set get }
    var bio: String { set get }
    var avatarUrl: String { set get }
    var firstName: String { set get }
    var lastName: String { set get }
}

struct ProfileEditDataItem: ProfileEditData {
    
    var username: String = ""
    var bio: String = ""
    var avatarUrl: String = ""
    var firstName: String = ""
    var lastName: String = ""
}
