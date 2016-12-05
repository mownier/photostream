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
    
    lazy var comments: [CommentFeedData]! = [CommentFeedData]()
    
    weak var view: ModuleView!
    var wireframe: ModuleWireframe!
    var interactor: ModeuleInteractor!
    var postId: String!
    var limit: UInt! = 10
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
        interactor.fetchNext(with: postId, and: limit)
    }
    
    func refreshComments() {
        interactor.fetchNew(with: postId, and: limit)
        if comments.count == 0 {
            view.hideEmptyView()
            view.showInitialLoadView()
        }
        view.showRefreshView()
    }
    
    func comment(at index: Int) -> CommentFeedData? {
        return comments[index]
    }
}

extension CommentFeedPresenter: CommentFeedInteractorOutput {
    
    func commentFeedDidRefresh(with feed: [CommentFeedData]) {
        view.hideInitialLoadView()
        view.hideRefreshView()
        
        guard !(feed.count == 0 && comments.count == 0) else {
            view.reload()
            view.showEmptyView()
            return
        }
        
        comments.removeAll()
        comments.append(contentsOf: feed)
        
        view.didRefreshComments(with: nil)
        view.reload()
    }
    
    func commentFeedDidLoadMore(with feed: [CommentFeedData]) {
        guard feed.count > 0 else {
            return
        }
        
        comments.append(contentsOf: feed)
        
        view.didLoadMoreComments(with: nil)
        view.reload()
    }
    
    func commentFeedDidRefresh(with error: CommentServiceError) {
        view.hideInitialLoadView()
        view.hideRefreshView()
        
        if comments.count == 0 {
            view.showEmptyView()
        }
        
        view.didRefreshComments(with: error.message)
        view.reload()
    }
    
    func commentFeedDidLoadMore(with error: CommentServiceError) {
        view.hideInitialLoadView()
        view.hideRefreshView()
        
        view.didLoadMoreComments(with: error.message)
        view.reload()
    }
}
