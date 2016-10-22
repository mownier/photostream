//
//  PostService.swift
//  Photostream
//
//  Created by Mounir Ybanez on 06/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

protocol PostService {

    init(session: AuthSession)
    
    func fetchPostInfo(id: String, callback: ((PostServiceResult) -> Void)?)
    func fetchPosts(userId: String, offset: UInt, limit: UInt, callback: ((PostServiceResult) -> Void)?)
    func writePost(imageUrl: String, callback: ((PostServiceResult) -> Void)?)
    
    func fetchLikes(id: String, offset: UInt, limit: UInt, callback: ((PostServiceLikeResult) -> Void)?)
    func like(id: String, callback: ((PostServiceError?) -> Void)?)
    func unlike(id: String, callback: ((PostServiceError?) -> Void)?)
}

struct PostServiceResult {

    var posts: PostList?
    var error: PostServiceError?
}

struct PostServiceLikeResult {
    
    var likes: [User]?
    var error: PostServiceError?
}

enum PostServiceError: Error {
    
    case authenticationNotFound(message: String)
    case failedToFetch(message: String)
    case failedToWrite(message: String)
    case failedToLike(message: String)
    case failedToUnlike(message: String)
    case failedToFetchLikes(message: String)
    
    var message: String {
        switch self {
        case .authenticationNotFound(let message),
             .failedToFetch(let message),
             .failedToWrite(let message),
             .failedToLike(let message),
             .failedToUnlike(let message),
             .failedToFetchLikes(let message):
            return message
        }
    }
}
