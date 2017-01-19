//
//  SinglePostModule.swift
//  Photostream
//
//  Created by Mounir Ybanez on 19/01/2017.
//  Copyright © 2017 Mounir Ybanez. All rights reserved.
//

protocol SinglePostModuleInterface: BaseModuleInterface {
    
    var postData: SinglePostData? { get }
    
    func viewDidLoad()
    
    func fetchPost()
    
    func likePost()
    func unlikePost()
    func toggleLike()
}

protocol SinglePostBuilder: BaseModuleBuilder {
    
    func build(root: RootWireframe?, postId: String)
}

class SinglePostModule: BaseModule, BaseModuleInteractable {

    typealias ModuleView = SinglePostScene
    typealias ModuleInteractor = SinglePostInteractor
    typealias ModulePresenter = SinglePostPresenter
    typealias ModuleWireframe = SinglePostWireframe
    
    var view: ModuleView!
    var interactor: ModuleInteractor!
    var presenter: ModulePresenter!
    var wireframe: ModuleWireframe!
    
    required init(view: ModuleView) {
        self.view = view
    }
}

extension SinglePostModule: SinglePostBuilder {
    
    func build(root: RootWireframe?) {
        let auth = AuthSession()
        let service = PostServiceProvider(session: auth)
        interactor = SinglePostInteractor(service: service)
        presenter = SinglePostPresenter()
        wireframe = SinglePostWireframe(root: root)
        
        view.presenter = presenter
        interactor.output = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.wireframe = wireframe
    }
    
    func build(root: RootWireframe?, postId: String) {
        build(root: root)
        presenter.postId = postId
    }
}
