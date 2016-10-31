//
//  NewsFeedInteractorOutput.swift
//  Photostream
//
//  Created by Mounir Ybanez on 06/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

protocol NewsFeedInteractorOutput {

    mutating func newsFeedDidRefresh(data: NewsFeedDataCollection)
    mutating func newsFeedDidLoadMore(data: NewsFeedDataCollection)
    func newsFeedDidFetchWithError(error: NewsFeedServiceError)
    
    mutating func newsFeedDidLike(with error: NewsFeedServiceError?)
    mutating func newsFeedDidUnlike(with error: NewsFeedServiceError?)
}
