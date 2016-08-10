//
//  PostService.swift
//  Photostream
//
//  Created by Mounir Ybanez on 06/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

typealias PostServiceCallback = (PostServiceResult?, NSError?) -> Void

protocol PostService: class {

    func fetchNewsFeed(userId: String!, offset: UInt!, limit: UInt!, callback: PostServiceCallback!)
    func fetchPosts(userId: String!, offset: UInt!, limit: UInt!, callback: PostServiceCallback!)
    func writePost(userId: String!, imageUrl: String!, callback: PostServiceCallback!)
}

struct PostServiceResult {

    var posts: [Post]!
    var users: [String: User]!
}
