//
//  PostLikeData.swift
//  Photostream
//
//  Created by Mounir Ybanez on 20/01/2017.
//  Copyright © 2017 Mounir Ybanez. All rights reserved.
//

protocol PostLikeData {
    
    var userId: String { set get }
    var displayName: String { set get }
    var avatarUrl: String { set get }
    var isFollowing: Bool { set get }
    var isMe: Bool { set get }
}

struct PostLikeDataItem: PostLikeData {

    var userId: String = ""
    var displayName: String = ""
    var avatarUrl: String = ""
    var isFollowing: Bool = false
    var isMe: Bool = false
}
