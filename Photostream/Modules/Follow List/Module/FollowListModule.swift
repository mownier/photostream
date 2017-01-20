//
//  FollowListModule.swift
//  Photostream
//
//  Created by Mounir Ybanez on 17/01/2017.
//  Copyright © 2017 Mounir Ybanez. All rights reserved.
//

protocol FollowListModuleInterface: BaseModuleInterface {
    
    var listCount: Int { get }
    var navigationItemTitle: String { get }
    
    func viewDidLoad()
    func listItem(at index: Int) -> FollowListDisplayData?
    
    func initialLoad()
    func refresh()
    func loadMore()
    
    func toggleFollow(at index: Int)
    func follow(at index: Int)
    func unfollow(at index: Int)
}

protocol FollowListDelegate: BaseModuleDelegate {
    
    func followListDidFollow(isMe: Bool)
    func followListDidUnfollow(isMe: Bool)
}

protocol FollowListBuilder: BaseModuleBuilder {
    
    func build(root: RootWireframe?, userId: String, fetchType: FollowListFetchType, delegate: FollowListDelegate?)
}

class FollowListModule: BaseModule, BaseModuleInteractable {

    typealias ModuleView = FollowListScene
    typealias ModuleInteractor = FollowListInteractor
    typealias ModulePresenter = FollowListPresenter
    typealias ModuleWireframe = FollowListWireframe
    
    var view: ModuleView!
    var interactor: ModuleInteractor!
    var presenter: ModulePresenter!
    var wireframe: ModuleWireframe!
    
    required init(view: ModuleView) {
        self.view = view
    }
}

extension FollowListModule: FollowListBuilder {
    
    func build(root: RootWireframe?) {
        let auth = AuthSession()
        let service = UserServiceProvider(session: auth)
        interactor = FollowListInteractor(service: service)
        presenter = FollowListPresenter()
        wireframe = FollowListWireframe(root: root)
        
        view.presenter = presenter
        interactor.output = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.wireframe = wireframe
    }
    
    func build(root: RootWireframe?, userId: String, fetchType: FollowListFetchType, delegate: FollowListDelegate?) {
        build(root: root)
        presenter.delegate = delegate
        presenter.userId = userId
        presenter.fetchType = fetchType
        
        let auth = AuthSession()
        presenter.isMe = auth.user.id == userId
    }
}
