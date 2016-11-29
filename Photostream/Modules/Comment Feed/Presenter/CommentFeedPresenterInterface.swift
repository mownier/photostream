//
//  CommentFeedPresenterInterface.swift
//  Photostream
//
//  Created by Mounir Ybanez on 28/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

protocol CommentFeedPresenterInterface: BaseModulePresenter, BaseModuleInteractable {

    var postId: String! { set get }
    var comments: [CommentFeedDataItem]! { set get }
    var offset: String! { set get }
    var limit: Int! { set get }
}
