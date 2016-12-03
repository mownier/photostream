//
//  CommentFeedInteractorInput.swift
//  Photostream
//
//  Created by Mounir Ybanez on 28/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

protocol CommentFeedInteractorInput: BaseModuleInteractorInput {

    func fetchNew(with postId: String, and limit: UInt)
    func fetchNext(with postId: String, and limit: UInt)
}
