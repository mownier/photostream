//
//  UserService.swift
//  Photostream
//
//  Created by Mounir Ybanez on 10/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

typealias UserServiceCallback = (NSError?) -> Void
typealias UserServiceProfileCallback = ()

protocol UserService: class {

    func follow(userId: String!, callback: UserServiceCallback!)
    func unfollow(userId: String!, callback: UserServiceCallback!)
    func fetchProfile(userId: String!)
}
