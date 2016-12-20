//
//  PostDiscoveryModule.swift
//  Photostream
//
//  Created by Mounir Ybanez on 20/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

protocol PostDiscoveryModuleInterface: BaseModuleInterface {
    
    var postCount: Int { get }
    
    func initialLoad()
    func refreshPosts()
    func loadMorePosts()
    
    func unlikePost(at index: Int)
    func likePost(at index: Int)
    func toggleLike(at index: Int)
    
    func post(at index: Int) -> PostDiscoveryData?
}

protocol PostDiscoveryBuilder: BaseModuleBuilder { }

class PostDiscoveryModule: BaseModule, BaseModuleInteractable {
    
    typealias ModuleView = PostDiscoveryScene
    typealias ModuleInteractor = PostDiscoveryInteractor
    typealias ModulePresenter = PostDiscoveryPresenter
    typealias ModuleWireframe = PostDiscoveryWireframe
    
    var view: ModuleView!
    var interactor: ModuleInteractor!
    var presenter: ModulePresenter!
    var wireframe: ModuleWireframe!
    
    required init(view: ModuleView) {
        self.view = view
    }
}

extension PostDiscoveryModule: PostDiscoveryBuilder {
    
    func build(root: RootWireframe?) {
        let auth = AuthSession()
        let service = PostServiceProvider(session: auth)
        interactor = PostDiscoveryInteractor(service: service)
        presenter = PostDiscoveryPresenter()
        wireframe = PostDiscoveryWireframe(root: root)
        
        interactor.output = presenter
        view.presenter = presenter
        
        presenter.interactor = interactor
        presenter.view = view
        presenter.wireframe = wireframe
    }
}
