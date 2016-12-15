//
//  LogoutModule.swift
//  Photostream
//
//  Created by Mounir Ybanez on 15/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

protocol LogoutModuleInterface: BaseModuleInterface {
    
    func logout()
}

protocol LogoutModuleBuilder: BaseModuleBuilder { }

class LogoutModule: BaseModule, BaseModuleInteractable {

    typealias ModuleView = LogoutScene
    typealias ModuleInteractor = LogoutInteractor
    typealias ModulePresenter = LogoutPresenter
    typealias ModuleWireframe = LogoutWireframe
    
    var view: ModuleView!
    var interactor: ModuleInteractor!
    var presenter: ModulePresenter!
    var wireframe: ModuleWireframe!
    
    required init(view: ModuleView) {
        self.view = view
    }
}

extension LogoutModule: LogoutModuleBuilder {
    
    func build(root: RootWireframe?) {
        interactor = LogoutInteractor(service: AuthenticationServiceProvider())
        presenter = LogoutPresenter()
        wireframe = LogoutWireframe(root: root)
        
        view.presenter = presenter
        interactor.output = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.wireframe = wireframe
    }
}
