//
//  UserProfileData.swift
//  Photostream
//
//  Created by Mounir Ybanez on 10/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

protocol UserProfileData {

    var id: String { set get }
    var avatarUrl: String { set get }
    var username: String { set get }
    var firstName: String { set get }
    var lastName: String { set get }
    var displayName: String { get }
    var postCount: Int { set get }
    var followerCount: Int { set get }
    var followingCount: Int { set get }
    var bio: String { set get }
    var isFollowed: Bool { set get }
}

struct UserProfileDataItem: UserProfileData {
    
    var id: String = ""
    var avatarUrl: String = ""
    var username: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var bio: String = ""
    var postCount: Int = 0
    var followerCount: Int = 0
    var followingCount: Int = 0
    var isFollowed: Bool = false
    var displayName: String {
        return username.isEmpty ? firstName : username
    }
}
