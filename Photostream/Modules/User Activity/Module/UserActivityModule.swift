//
//  UserActivityModule.swift
//  Photostream
//
//  Created by Mounir Ybanez on 23/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

protocol UserActivityModuleInterface: BaseModuleInterface {
    
    var activityCount: Int { get }
    
    func viewDidLoad()
    func refreshActivities()
    func loadMoreActivities()
    
    func activity(at index: Int) -> UserActivityData?
}

protocol UserActivityBuilder: BaseModuleBuilder {
    
    func build(root: RootWireframe?, userId: String)
}

class UserActivityModule: BaseModule, BaseModuleInteractable {
    
    typealias ModuleView = UserActivityScene
    typealias ModuleInteractor = UserActivityInteractor
    typealias ModulePresenter = UserActivityPresenter
    typealias ModuleWireframe = UserActivityWireframe
    
    var view: ModuleView!
    var interactor: ModuleInteractor!
    var presenter: ModulePresenter!
    var wireframe: ModuleWireframe!
    
    required init(view: ModuleView) {
        self.view = view
    }
}

extension UserActivityModule: UserActivityBuilder {
    
    func build(root: RootWireframe?) {
        let service = UserServiceProvider(session: AuthSession())
        interactor = UserActivityInteractor(service: service)
        presenter = UserActivityPresenter()
        wireframe = UserActivityWireframe(root: root)
        
        view.presenter = presenter
        interactor.output = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.wireframe = wireframe
    }
    
    func build(root: RootWireframe?, userId: String) {
        build(root: root)
        presenter.userId = userId
    }
}
