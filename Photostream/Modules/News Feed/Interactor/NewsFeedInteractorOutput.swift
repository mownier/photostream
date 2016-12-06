//
//  NewsFeedInteractorOutput.swift
//  Photostream
//
//  Created by Mounir Ybanez on 06/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

protocol NewsFeedInteractorOutput: class {

    func newsFeedDidRefresh(data: NewsFeedData)
    func newsFeedDidLoadMore(data: NewsFeedData)
    func newsFeedDidFetchWithError(error: NewsFeedServiceError)
    
    func newsFeedDidLike(with postId: String, and error: PostServiceError?)
    func newsFeedDidUnlike(with postId: String, and error: PostServiceError?)
}
