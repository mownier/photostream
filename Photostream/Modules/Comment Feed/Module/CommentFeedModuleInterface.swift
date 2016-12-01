//
//  CommentFeedModuleInterface.swift
//  Photostream
//
//  Created by Mounir Ybanez on 28/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

protocol CommentFeedModuleInterface: BaseModuleInterface {

    var commentCount: Int { get }
    
    func refreshComments()
    func loadMoreComments()
    
    func comment(at index: Int) -> CommentFeedData?
}
