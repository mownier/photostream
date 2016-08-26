//
//  NewsFeedDataCollection.swift
//  Photostream
//
//  Created by Mounir Ybanez on 20/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

struct NewsFeedDataCollection {

    var posts: [NewsFeedPostData]
    var users: [String: NewsFeedUserData]

    var count: Int {
        get {
            return posts.count
        }
    }

    init() {
        posts = [NewsFeedPostData]()
        users = [String: NewsFeedUserData]()
    }

    mutating func add(postItem: NewsFeedPostData, userItem: NewsFeedUserData) {
        posts.append(postItem)
        if users[postItem.userId] == nil {
            users[postItem.userId] = userItem
        }
    }

    subscript (index: Int) -> (NewsFeedPostData, NewsFeedUserData)? {
        if posts.isValid(index) {
            let post = posts[index]
            if let user = users[post.userId] {
                return (post, user)
            }
        }
        return nil
    }
}

struct NewsFeedPostData {

    var postId: String
    var likesCount: Int
    var commentsCount: Int
    var message: String
    var timestamp: Double
    var isLiked: Bool
    var userId: String
    var photoUrl: String
    var photoWidth: Int
    var photoHeight: Int

    init() {
        postId = ""
        likesCount = 0
        commentsCount = 0
        message = ""
        timestamp = 0
        isLiked = false
        userId = ""
        photoUrl = ""
        photoWidth = 0
        photoHeight = 0
    }
}

struct NewsFeedUserData {

    var userId: String
    var avatarUrl: String
    var displayName: String

    init() {
        userId = ""
        avatarUrl = ""
        displayName = ""
    }
}
