//
//  CommentFeedInteractorOutput.swift
//  Photostream
//
//  Created by Mounir Ybanez on 28/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

protocol CommentFeedInteractorOutput: BaseModuleInteractorOutput {

    func commentFeedDidFetch(with feed: [CommentFeedData])
    func commentFeedDidFetch(with error: CommentServiceError)
}
