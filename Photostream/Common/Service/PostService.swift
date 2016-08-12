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
    func fetchNewsFeed(offset: UInt!, limit: UInt!, callback: PostServiceCallback!)
    func fetchPosts(userId: String!, offset: UInt!, limit: UInt!, callback: PostServiceCallback!)
    func writePost(imageUrl: String!, callback: PostServiceCallback!)
    func like(postId: String!, callback: PostServiceLikeCallback!)
    func unlike(postId: String!, callback: PostServiceLikeCallback!)
    func fetchLikes(postId: String, offset: UInt!, limit: UInt!, callback: PostServiceLikeListCallback!)
}

struct PostServiceResult {

    var posts: [Post]!
    var users: [String: User]!
}
