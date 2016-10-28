//
//  RegistrationWireframe.swift
//  Photostream
//
//  Created by Mounir Ybanez on 13/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

struct RegistrationWireframe: RegistrationWireframeInterface {

    var presenter: RegistrationPresenterInterface!
    var root: RootWireframeInterface?
    
    init(view: RegistrationViewInterface) {
        presenter = RegistrationPresenter()
        presenter.view = view
        presenter.wireframe = self
        let service = AuthenticationServiceProvider()
        var interactor = RegistrationInteractor(service: service)
        interactor.output = presenter as! RegistrationInteractorOutput?
        presenter.interactor = interactor
    }
    
    func attachAsRoot(in window: UIWindow) {
        guard let controller = presenter.view?.controller else {
            return
        }
        
        root?.showRoot(with: controller, in: window)
    }
    
    func showErrorAlert(title: String, message: String) {
        guard let controller = presenter.view?.controller else {
            return
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        controller.present(alert, animated: true, completion: nil)
    }
}
