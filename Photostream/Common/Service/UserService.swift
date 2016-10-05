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
    func follow(_ userId: String!, callback: UserServiceFollowCallback!)
    func unfollow(_ userId: String!, callback: UserServiceFollowCallback!)
    func fetchFollowers(_ userId: String!, offset: UInt!, limit: UInt!, callback: UserServiceFollowListCallback!)
    func fetchFollowing(_ userId: String!, offset: UInt!, limit: UInt!, callback: UserServiceFollowListCallback!)
    func fetchProfile(_ userId: String!, callback: @escaping UserServiceProfileCallback)
}

struct UserServiceProfileResult {

    var user: User!
    var profile: Profile!
}
