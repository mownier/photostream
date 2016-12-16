//
//  NewsFeedModule.swift
//  Photostream
//
//  Created by Mounir Ybanez on 03/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

protocol NewsFeedModuleInterface: BaseModuleInterface {

    var feedCount: Int { get }
    
    func initialLoad()
    func refreshFeeds()
    func loadMoreFeeds()
    
    func toggleLike(at index: Int)
    func likePost(at index: Int)
    func unlikePost(at index: Int)
    
    func feed(at index: Int) -> NewsFeedDataItem?
}

protocol NewsFeedBuilder: BaseModuleBuilder { }

class NewsFeedModule: BaseModule, BaseModuleInteractable {
    
    typealias ModuleView = NewsFeedScene
    typealias ModuleInteractor = NewsFeedInteractor
    typealias ModulePresenter = NewsFeedPresenter
    typealias ModuleWireframe = NewsFeedWireframe
    
    var view: ModuleView!
    var interactor: ModuleInteractor!
    var presenter: ModulePresenter!
    var wireframe: ModuleWireframe!
    
    required init(view: ModuleView) {
        self.view = view
    }
}

extension NewsFeedModule: BaseModuleBuilder {
    
    func build(root: RootWireframe?) {
        let auth = AuthSession()
        let feed = NewsFeedServiceProvider(session: auth)
        let post = PostServiceProvider(session: auth)
        interactor = NewsFeedInteractor(feedService: feed, postService: post)
        presenter = NewsFeedPresenter()
        wireframe = NewsFeedWireframe(root: root)
        
        interactor.output = presenter
        view.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.wireframe = wireframe
    }
}
