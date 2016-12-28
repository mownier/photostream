//
//  UserActivityData.swift
//  Photostream
//
//  Created by Mounir Ybanez on 22/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

protocol UserActivityData {
    
    var timestamp: Double { set get }
    
    var userId: String { set get }
    var avatarUrl: String { set get }
    var displayName: String { set get }
}


protocol UserActivityLikeData: UserActivityData {
    
    var photoUrl: String { set get }
    var postId: String { set get }
}

protocol UserActivityPostData: UserActivityData {
    
    var photoUrl: String { set get }
    var postId: String { set get }
}

protocol UserActivityCommentData: UserActivityData {
    
    var commentId: String { set get }
    var message: String { set get }
    
    var photoUrl: String { set get }
    var postId: String { set get }
}

protocol UserActivityFollowData: UserActivityData {
    
    var isFollowing: Bool { set get }
}

struct UserActivityLikeDataItem: UserActivityLikeData {
    
    var timestamp: Double = 0
    
    var userId: String = ""
    var avatarUrl: String = ""
    var displayName: String = ""
    
    var photoUrl: String = ""
    var postId: String = ""
    
    init(user: User, post: Post) {
        userId = user.id
        avatarUrl = user.avatarUrl
        displayName = user.displayName
        
        photoUrl = post.photo.url
        postId = post.id
    }
}

struct UserActivityPostDataItem: UserActivityLikeData {
    
    var timestamp: Double = 0
    
    var userId: String = ""
    var avatarUrl: String = ""
    var displayName: String = ""
    
    var photoUrl: String = ""
    var postId: String = ""
    
    init(user: User, post: Post) {
        userId = user.id
        avatarUrl = user.avatarUrl
        displayName = user.displayName
        
        photoUrl = post.photo.url
        postId = post.id
    }
}

struct UserActivityCommentDataItem: UserActivityCommentData {
    
    var timestamp: Double = 0
    
    var userId: String = ""
    var avatarUrl: String = ""
    var displayName: String = ""
    
    var commentId: String = ""
    var message: String = ""
    
    var photoUrl: String = ""
    var postId: String = ""
    
    init(user: User, comment: Comment, post: Post) {
        userId = user.id
        avatarUrl = user.avatarUrl
        displayName = user.displayName
        
        commentId = comment.id
        message = comment.message
        
        photoUrl = post.photo.url
        postId = post.id
    }
}

struct UserActivityFollowDataItem: UserActivityFollowData {
    
    var timestamp: Double = 0
    
    var userId: String = ""
    var avatarUrl: String = ""
    var displayName: String = ""
    
    var isFollowing: Bool = false
    
    init(user: User) {
        userId = user.id
        avatarUrl = user.avatarUrl
        displayName = user.displayName
    }
}
