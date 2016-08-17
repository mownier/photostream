//
//  NewsFeedInteractor.swift
//  Photostream
//
//  Created by Mounir Ybanez on 06/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

class NewsFeedInteractor: NewsFeedInteractorInput {

    var output: NewsFeedInteractorOutput!
    var service: PostService!
    var currentOffset: UInt!
    var list: PostServiceResult!

    var feedCount: Int! {
        get {
            return list.posts.count
        }
    }

    init(service: PostService!) {
        self.service = service
        self.currentOffset = 0
        self.list = PostServiceResult()
    }

    func fetchNew(limit: UInt!) {
        currentOffset = 0
        fetch(currentOffset, limit: limit)
    }

    func fetchNext(limit: UInt!) {
        currentOffset = currentOffset + UInt(1)
        fetch(currentOffset, limit: limit)
    }

    func fetchPost(index: UInt!) -> (Post!, User!) {
        let i = Int(index)
        let post = list.posts[i]
        let user = list.users[post.userId]
        return (post, user)
    }

    private func fetch(offset: UInt!, limit: UInt!) {
        service.fetchNewsFeed(currentOffset, limit: limit) { (feed, error) in
            if let error = error {
                self.output.newsFeedDidFetchWithError(error)
            } else {
                if let f = feed {
                    self.list.posts = f.posts
                    self.list.users = f.users
                }
                self.output.newsFeedDidFetchOk()
            }
        }
    }
}
