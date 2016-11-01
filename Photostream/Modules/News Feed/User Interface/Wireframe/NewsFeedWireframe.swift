//
//  NewsFeedWireframe.swift
//  Photostream
//
//  Created by Mounir Ybanez on 17/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

struct NewsFeedWireframe: NewsFeedWireframeInterface {

    var root: RootWireframeInterface?
    
    init(root: RootWireframeInterface?, view: NewsFeedViewInterface) {
        self.root = root
        
        let session = AuthSession()
        let feedService = NewsFeedServiceProvider(session: session)
        let postService = PostServiceProvider(session: session)
        var interactor = NewsFeedInteractor(feedService: feedService, postService: postService)
        var presenter = NewsFeedPresenter()
        
        presenter.view = view
        presenter.wireframe = self
        
        interactor.output = presenter
        presenter.interactor = interactor
        
        view.presenter = presenter
    }

    func attachRoot(with controller: UIViewController, in window: UIWindow) {
        root?.showRoot(with: controller, in: window)
    }
}
