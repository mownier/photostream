//
//  CommentFeedPresenter.swift
//  Photostream
//
//  Created by Mounir Ybanez on 28/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

class CommentFeedPresenter: CommentFeedPresenterInterface {

    typealias ModuleView = CommentFeedScene
    typealias ModuleWireframe = CommentFeedWireframeInterface
    typealias ModeuleInteractor = CommentFeedInteractorInput
    
    lazy var comments: [CommentFeedDataItem]! = [CommentFeedDataItem]()
    
    var view: ModuleView!
    var wireframe: ModuleWireframe!
    var interactor: ModeuleInteractor!
    var postId: String!
    var offset: String! = ""
    var limit: Int! = 10
}

extension CommentFeedPresenter: CommentFeedModuleInterface {
    
    var commentCount: Int {
        return comments.count
    }
    
    func exit() {
        var property = WireframeExitProperty()
        property.controller = view.controller
        wireframe.exit(with: property)
    }
    
    func loadMoreComments() {
        interactor.fetchComments(with: postId)
    }
    
    func refreshComments() {
        interactor.fetchComments(with: postId)
    }
    
    func comment(at index: Int) -> CommentFeedDataItem? {
        return comments[index]
    }
}

extension CommentFeedPresenter: CommentFeedInteractorOutput {
    
    func commentFeedDidFetch(with feed: [CommentFeedDataItem]) {
        if offset.isEmpty {
            comments.removeAll()
            view.didRefreshComments(with: nil)
        } else {
            view.didLoadMoreComments(with: nil)
        }
        
        comments.append(contentsOf: feed)
        view.reload()
    }
    
    func commentFeedDidFetch(with error: CommentServiceError) {
        if offset.isEmpty {
            view.didRefreshComments(with: error.message)
        } else {
            view.didLoadMoreComments(with: error.message)
        }
    }
}
