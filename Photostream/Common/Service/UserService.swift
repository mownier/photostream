//
//  UserService.swift
//  Photostream
//
//  Created by Mounir Ybanez on 10/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

typealias UserServiceFollowCallback = (Bool, NSError?) -> Void
typealias UserServiceFollowListCallback = ([User]?, NSError?) -> Void
typealias UserServiceProfileCallback = (UserServiceProfileResult?, NSError?) -> Void

protocol UserService: class {

    init(session: AuthSession!)
    func follow(userId: String!, callback: UserServiceFollowCallback!)
    func unfollow(userId: String!, callback: UserServiceFollowCallback!)
    func fetchFollowers(userId: String!, offset: UInt!, limit: UInt!, callback: UserServiceFollowListCallback!)
    func fetchFollowing(userId: String!, offset: UInt!, limit: UInt!, callback: UserServiceFollowListCallback!)
    func fetchProfile(userId: String!, callback: UserServiceProfileCallback)
}

struct UserServiceProfileResult {

    var user: User!
    var profile: Profile!
}
