//
//  LogoutPresenter.swift
//  Photostream
//
//  Created by Mounir Ybanez on 15/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

protocol LogoutPresenterInterface: BaseModulePresenter, BaseModuleInteractable { }

class LogoutPresenter: LogoutPresenterInterface {
    
    typealias ModuleView = LogoutScene
    typealias ModuleInteractor = LogoutInteractorInput
    typealias ModuleWireframe = LogoutWireframeInterface
    
    weak var view: ModuleView!
    
    var interactor: ModuleInteractor!
    var wireframe: ModuleWireframe!
}

extension LogoutPresenter: LogoutModuleInterface {
    
    func logout() {
        interactor.logout()
    }
    
    func exit() {
        var property = WireframeExitProperty()
        property.controller = view.controller
        wireframe.exit(with: property)
    }
}

extension LogoutPresenter: LogoutInteractorOutput {
    
    func didLogoutOk() {
        view.didLogout(with: nil)
    }
    
    func didLogoutFail(with error: AuthenticationServiceError) {
        view.didLogout(with: error.message)
    }
}
