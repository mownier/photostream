//
//  CommentFeedModule.swift
//  Photostream
//
//  Created by Mounir Ybanez on 28/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

class CommentFeedModule: BaseModule, BaseModuleInteractable {
    
    typealias ModuleWireframe = CommentFeedWireframe
    typealias ModuleView = CommentFeedScene
    typealias ModulePresenter = CommentFeedPresenter
    typealias ModuleInteractor = CommentFeedInteractor
    
    var view: ModuleView!
    var interactor: ModuleInteractor!
    var presenter: ModulePresenter!
    var wireframe: ModuleWireframe!
    
    required init(view: ModuleView) {
        self.view = view
    }
}

protocol CommentFeedBuilder: BaseModuleBuilder {
    
    func build(root: RootWireframe?, postId: String)
}

extension CommentFeedModule: CommentFeedBuilder {
    
    func build(root: RootWireframe?) {
        let service = CommentServiceProvider(session: AuthSession())
        interactor = CommentFeedInteractor(service: service)
        presenter = CommentFeedPresenter()
        wireframe = CommentFeedWireframe(root: root)
        
        presenter.interactor = interactor
        presenter.view = view
        presenter.wireframe = wireframe
        
        interactor.output = presenter
        view.presenter = presenter
    }
    
    func build(root: RootWireframe?, postId: String) {
        build(root: root)
        presenter.postId = postId
    }
}
