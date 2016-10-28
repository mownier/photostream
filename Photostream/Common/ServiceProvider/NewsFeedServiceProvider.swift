//
//  NewsFeedServiceProvider.swift
//  Photostream
//
//  Created by Mounir Ybanez on 22/10/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

struct NewsFeedServiceProvider: NewsFeedService {

    var session: AuthSession
    
    init(session: AuthSession) {
        self.session = session
    }
    
    func fetchNewsFeed(offset: UInt, limit: UInt, callback: ((NewsFeedServiceResult) -> Void)?) {
        var result = NewsFeedServiceResult()
        guard session.isValid else {
            result.error = .authenticationNotFound(message: "Authentication not found")
            callback?(result)
            return
        }
        // TODO: Implement fetching of news feed
    }
}
