//
//  NewsFeedInteractorOutput.swift
//  Photostream
//
//  Created by Mounir Ybanez on 06/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

protocol NewsFeedInteractorOutput {

    mutating func newsFeedDidRefresh(data: NewsFeedData)
    mutating func newsFeedDidLoadMore(data: NewsFeedData)
    func newsFeedDidFetchWithError(error: NewsFeedServiceError)
    
    mutating func newsFeedDidLike(with error: PostServiceError?)
    mutating func newsFeedDidUnlike(with error: PostServiceError?)
}
