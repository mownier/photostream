//
//  PostService.swift
//  Photostream
//
//  Created by Mounir Ybanez on 06/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

typealias PostServiceCallback = (PostServiceResult?, NSError?) -> Void
typealias PostServiceLikeCallback = (Bool, NSError?) -> Void
typealias PostServiceLikeListCallback = ([User]?, NSError?) -> Void

protocol PostService: class {

    init(session: AuthSession!)
    func fetchNewsFeed(_ offset: UInt!, limit: UInt!, callback: PostServiceCallback!)
    func fetchPosts(_ userId: String!, offset: UInt!, limit: UInt!, callback: PostServiceCallback!)
    func writePost(_ imageUrl: String!, callback: PostServiceCallback!)
    func like(_ postId: String!, callback: PostServiceLikeCallback!)
    func unlike(_ postId: String!, callback: PostServiceLikeCallback!)
    func fetchLikes(_ postId: String, offset: UInt!, limit: UInt!, callback: PostServiceLikeListCallback!)
}

struct PostServiceResult {

    var posts: [Post]!
    var users: [String: User]!
    var count: Int {
        return posts.count
    }

    init() {
        posts =  [Post]()
        users = [String: User]()
    }

    subscript (index: Int) -> (Post, User)? {
        if posts.isValid(index) {
            let post = posts[index]
            if let user = users[post.userId] {
                return (post, user)
            }
        }
        return nil
    }
}
