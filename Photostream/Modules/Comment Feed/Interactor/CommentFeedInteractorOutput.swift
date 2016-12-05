//
//  CommentFeedInteractorOutput.swift
//  Photostream
//
//  Created by Mounir Ybanez on 28/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

protocol CommentFeedInteractorOutput: BaseModuleInteractorOutput {

    func commentFeedDidRefresh(with feed: [CommentFeedData])
    func commentFeedDidLoadMore(with feed: [CommentFeedData])
    func commentFeedDidRefresh(with error: CommentServiceError)
    func commentFeedDidLoadMore(with error: CommentServiceError)
}
