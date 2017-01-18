
//
//  FollowListData.swift
//  Photostream
//
//  Created by Mounir Ybanez on 17/01/2017.
//  Copyright © 2017 Mounir Ybanez. All rights reserved.
//

protocol FollowListData {
    
    var userId: String { set get }
    var displayName: String { set get }
    var avatarUrl: String { set get }
    var isFollowing: Bool { set get }
    var isMe: Bool { set get }
}

struct FollowListDataItem: FollowListData {

    var userId: String = ""
    var displayName: String = ""
    var avatarUrl: String = ""
    var isFollowing: Bool = false
    var isMe: Bool = false
}

enum FollowListFetchType {
    
    case followers, following
}
