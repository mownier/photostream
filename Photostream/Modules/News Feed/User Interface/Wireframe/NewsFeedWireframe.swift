//
//  NewsFeedWireframe.swift
//  Photostream
//
//  Created by Mounir Ybanez on 17/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class NewsFeedWireframe: NewsFeedWireframeInterface {

    var root: RootWireframeInterface?
    
    required init(root: RootWireframeInterface?, view: NewsFeedViewInterface) {
        self.root = root
        
        let session = AuthSession()
        let feedService = NewsFeedServiceProvider(session: session)
        let postService = PostServiceProvider(session: session)
        let interactor = NewsFeedInteractor(feedService: feedService, postService: postService)
        let presenter = NewsFeedPresenter()
        
        view.presenter = presenter
        interactor.output = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.wireframe = self
    }

    func attachRoot(with controller: UIViewController, in window: UIWindow) {
        root?.showRoot(with: controller, in: window)
    }
}
