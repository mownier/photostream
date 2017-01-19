//
//  LikedPostModule.swift
//  Photostream
//
//  Created by Mounir Ybanez on 19/01/2017.
//  Copyright © 2017 Mounir Ybanez. All rights reserved.
//

protocol LikedPostModuleInterface: BaseModuleInterface {
    
    var postCount: Int { get }
    
    func viewDidLoad()
    
    func refresh()
    func loadMore()
    
    func unlikePost(at index: Int)
    func likePost(at index: Int)
    func toggleLike(at index: Int)
    
    func post(at index: Int) -> LikedPostData?
}

protocol LikedPostBuilder: BaseModuleBuilder {
    
    func build(root: RootWireframe?, userId: String)
}

class LikedPostModule: BaseModule, BaseModuleInteractable {
    
    typealias ModuleView = LikedPostScene
    typealias ModuleInteractor = LikedPostInteractor
    typealias ModulePresenter = LikedPostPresenter
    typealias ModuleWireframe = LikedPostWireframe
    
    var view: ModuleView!
    var interactor: ModuleInteractor!
    var presenter: ModulePresenter!
    var wireframe: ModuleWireframe!
    
    required init(view: ModuleView) {
        self.view = view
    }
}

extension LikedPostModule: LikedPostBuilder {
    
    func build(root: RootWireframe?) {
        let auth = AuthSession()
        let service = PostServiceProvider(session: auth)
        interactor = LikedPostInteractor(service: service)
        presenter = LikedPostPresenter()
        wireframe = LikedPostWireframe(root: root)
        
        interactor.output = presenter
        view.presenter = presenter
        
        presenter.interactor = interactor
        presenter.view = view
        presenter.wireframe = wireframe
    }
    
    func build(root: RootWireframe?, userId: String) {
        build(root: root)
        presenter.userId = userId
    }
}
