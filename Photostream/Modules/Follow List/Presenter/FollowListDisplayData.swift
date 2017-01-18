//
//  FollowListDisplayData.swift
//  Photostream
//
//  Created by Mounir Ybanez on 18/01/2017.
//  Copyright © 2017 Mounir Ybanez. All rights reserved.
//

import Foundation

protocol FollowListDisplayData: FollowListData {

    var isBusy: Bool { set get }
}

struct FollowListDisplayDataItem: FollowListDisplayData {
    
    var userId: String = ""
    var displayName: String = ""
    var avatarUrl: String = ""
    var isFollowing: Bool = false
    var isMe: Bool = false
    var isBusy: Bool = false
}
