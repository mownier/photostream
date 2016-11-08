//
//  NewsFeedService.swift
//  Photostream
//
//  Created by Mounir Ybanez on 22/10/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

protocol NewsFeedService {
    
    init(session: AuthSession)
    func fetchNewsFeed(offset: String, limit: UInt, callback: ((NewsFeedServiceResult) -> Void)?)
}

struct NewsFeedServiceResult {

    var posts: PostList?
    var error: NewsFeedServiceError?
    var nextOffset: Any?
}

enum NewsFeedServiceError: Error {
    
    case authenticationNotFound(message: String)
    case failedToFetchNewsFeed(message: String)
    
    var message: String {
        switch self {
        case .authenticationNotFound(let message),
             .failedToFetchNewsFeed(let message):
            return message
        }
    }
}

