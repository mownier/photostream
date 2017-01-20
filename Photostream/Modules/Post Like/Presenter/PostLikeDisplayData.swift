//
//  PostLikeDisplayData.swift
//  Photostream
//
//  Created by Mounir Ybanez on 20/01/2017.
//  Copyright © 2017 Mounir Ybanez. All rights reserved.
//

protocol PostLikeDisplayData: PostLikeData {
    
    var isBusy: Bool { set get }
}

struct PostLikeDisplayDataItem: PostLikeDisplayData {
    
    var userId: String = ""
    var displayName: String = ""
    var avatarUrl: String = ""
    var isFollowing: Bool = false
    var isMe: Bool = false
    var isBusy: Bool = false
}
