//
//  CommentFeedPresenterInterface.swift
//  Photostream
//
//  Created by Mounir Ybanez on 28/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

protocol CommentFeedPresenterInterface: BaseModulePresenter, BaseModuleInteractable {

    var postId: String! { set get }
    var comments: [CommentFeedData]! { set get }
    var limit: UInt! { set get }
}
