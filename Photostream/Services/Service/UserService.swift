//
//  UserService.swift
//  Photostream
//
//  Created by Mounir Ybanez on 10/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

protocol UserService {

    init(session: AuthSession)
    func fetchBasicInfo(id: String, callback: ((UserServiceBasicResult) -> Void)?)
    
    func follow(id: String, callback: ((UserServiceError?) -> Void)?)
    func unfollow(id: String, callback: ((UserServiceError?) -> Void)?)
    func fetchFollowers(id: String, offset: String, limit: UInt, callback: ((UserServiceFollowListResult) -> Void)?)
    func fetchFollowing(id: String, offset: String, limit: UInt, callback: ((UserServiceFollowListResult) -> Void)?)
    
    func fetchProfile(id: String, callback: ((UserServiceProfileResult) -> Void)?)
    func fetchActivities(id: String, offset: String, limit: UInt, callback: ((UserServiceActivityListResult) -> Void)?)
    
    func editProfile(data: UserServiceProfileEditData, callback: ((UserServiceProfileEditResult) -> Void)?)
}

struct UserServiceProfileEditData {
    
    var firstName: String = ""
    var lastName: String = ""
    var bio: String = ""
    var avatarUrl: String = ""
    var username: String = ""
}

struct UserServiceProfileEditResult {
    
    var editData: UserServiceProfileEditData?
    var error: UserServiceError?
}

struct UserServiceBasicResult {
    
    var user: User?
    var error: UserServiceError?
}

struct UserServiceProfileResult {

    var user: User?
    var profile: Profile?
    var error: UserServiceError?
    var isFollowed: Bool = false
}

struct UserServiceFollowListResult {
    
    var users: [User]?
    var error: UserServiceError?
    var nextOffset: String?
    var following: [String: Bool]?
}

struct UserServiceActivityListResult {
    
    var list: ActivityList?
    var error: UserServiceError?
    var nextOffset: String?
}

enum UserServiceError: Error {
    
    case authenticationNotFound(message: String)
    case failedToFetchBasicInfo(message: String)
    case failedToFollow(message: String)
    case failedToUnfollow(message: String)
    case failedToFetchFollowers(message: String)
    case failedToFetchFollowing(message: String)
    case failedToFetchProfile(message: String)
    case failedToFetchActivities(message: String)
    case failedToEditProfile(message: String)
    case failedToChangeAvatar(message: String)
    
    var message: String {
        switch self {
        case .authenticationNotFound(let message),
             .failedToFetchBasicInfo(let message),
             .failedToFollow(let message),
             .failedToUnfollow(let message),
             .failedToFetchFollowers(let message),
             .failedToFetchFollowing(let message),
             .failedToFetchProfile(let message),
             .failedToFetchActivities(let message),
             .failedToEditProfile(let message),
             .failedToChangeAvatar(let message):
            return message
        }
    }
}
