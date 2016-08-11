//
//  UserService.swift
//  Photostream
//
//  Created by Mounir Ybanez on 10/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

typealias UserServiceFollowCallback = ([User]?, NSError?) -> Void
typealias UserServiceProfileCallback = (UserServiceProfileResult?, NSError?) -> Void

protocol UserService: class {

    func follow(userId: String!, callback: UserServiceFollowCallback!)
    func unfollow(userId: String!, callback: UserServiceFollowCallback!)
    func fetchFollowers(userId: String!, offset: UInt!, limit: UInt!, callback: UserServiceFollowCallback!)
    func fetchFollowing(userId: String!, offset: UInt!, limit: UInt!, callback: UserServiceFollowCallback!)
    func fetchProfile(userId: String!, callback: UserServiceProfileCallback)
}

struct UserServiceProfileResult {
    
    var user: User!
    var profile: Profile!
}
