//
//  UserProfileModule.swift
//  Photostream
//
//  Created by Mounir Ybanez on 10/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

protocol UserProfileModuleInterface: BaseModuleInterface {
    
    func fetchUserProfile()
    
    func follow()
    func unfollow()
}

protocol UserProfileDelegate: BaseModuleDelegate {
    
    func userProfileDidSetupInfo()
    func userProfileDidFollow()
    func userProfileDidUnfollow()
}

protocol UserProfileBuilder: BaseModuleBuilder {
    
    func build(root: RootWireframe?, userId: String, delegate: UserProfileDelegate?)
}

class UserProfileModule: BaseModule, BaseModuleInteractable {
    
    typealias ModuleView = UserProfileScene
    typealias ModuleInteractor = UserProfileInteractor
    typealias ModulePresenter = UserProfilePresenter
    typealias ModuleWireframe = UserProfileWireframe
    
    var view: ModuleView!
    var interactor: ModuleInteractor!
    var presenter: ModulePresenter!
    var wireframe: ModuleWireframe!

    required init(view: ModuleView) {
        self.view = view
    }
}

extension UserProfileModule: UserProfileBuilder {
    
    func build(root: RootWireframe?) {
        let service = UserServiceProvider(session: AuthSession())
        
        interactor = UserProfileInteractor(service: service)
        presenter = UserProfilePresenter()
        wireframe = UserProfileWireframe(root: root)
        
        interactor.output = presenter
        view.presenter = presenter
        
        presenter.interactor = interactor
        presenter.view = view
        presenter.wireframe = wireframe
    }
    
    func build(root: RootWireframe?, userId: String, delegate: UserProfileDelegate? = nil) {
        build(root: root)
        presenter.userId = userId
        presenter.delegate = delegate
    }
}
