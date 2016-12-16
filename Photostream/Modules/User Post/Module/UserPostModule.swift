//
//  UserPostModule.swift
//  Photostream
//
//  Created by Mounir Ybanez on 06/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

protocol UserPostModuleInterface: BaseModuleInterface {
    
    var postCount: Int { get }
    
    func initialLoad()
    func refreshPosts()
    func loadMorePosts()
    
    func unlikePost(at index: Int)
    func likePost(at index: Int)
    func toggleLike(at index: Int)
    
    func post(at index: Int) -> UserPostData?
}

protocol UserPostBuilder: BaseModuleBuilder {
    
    func build(root: RootWireframe?, userId: String)
}

class UserPostModule: BaseModule, BaseModuleInteractable {
    
    typealias ModuleView = UserPostScene
    typealias ModuleInteractor = UserPostInteractor
    typealias ModulePresenter = UserPostPresenter
    typealias ModuleWireframe = UserPostWireframe
    
    var view: ModuleView!
    var interactor: ModuleInteractor!
    var presenter: ModulePresenter!
    var wireframe: ModuleWireframe!
    
    required init(view: ModuleView) {
        self.view = view
    }
}

extension UserPostModule: UserPostBuilder {
    
    func build(root: RootWireframe?) {
        let auth = AuthSession()
        let service = PostServiceProvider(session: auth)
        interactor = UserPostInteractor(service: service)
        presenter = UserPostPresenter()
        wireframe = UserPostWireframe(root: root)
        
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
