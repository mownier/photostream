//
//  PostLikeModule.swift
//  Photostream
//
//  Created by Mounir Ybanez on 20/01/2017.
//  Copyright © 2017 Mounir Ybanez. All rights reserved.
//

protocol PostLikeModuleInterface: BaseModuleInterface {
    
    var likeCount: Int { get }
    
    func viewDidLoad()
    func like(at index: Int) -> PostLikeDisplayData?
    
    func initialLoad()
    func refresh()
    func loadMore()
    
    func toggleFollow(at index: Int)
    func follow(at index: Int)
    func unfollow(at index: Int)
}

protocol PostLikeBuilder: BaseModuleBuilder {
    
    func build(root: RootWireframe?, postId: String)
}

class PostLikeModule: BaseModule, BaseModuleInteractable {
    
    typealias ModuleView = PostLikeScene
    typealias ModuleInteractor = PostLikeInteractor
    typealias ModulePresenter = PostLikePresenter
    typealias ModuleWireframe = PostLikeWireframe
    
    var view: ModuleView!
    var interactor: ModuleInteractor!
    var presenter: ModulePresenter!
    var wireframe: ModuleWireframe!
    
    required init(view: ModuleView) {
        self.view = view
    }
}

extension PostLikeModule: PostLikeBuilder {
    
    func build(root: RootWireframe?) {
        let auth = AuthSession()
        let postService = PostServiceProvider(session: auth)
        let userService = UserServiceProvider(session: auth)
        interactor = PostLikeInteractor(postService: postService, userService: userService)
        presenter = PostLikePresenter()
        wireframe = PostLikeWireframe(root: root)
        
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
