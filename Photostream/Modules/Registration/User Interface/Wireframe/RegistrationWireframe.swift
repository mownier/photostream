//
//  RegistrationWireframe.swift
//  Photostream
//
//  Created by Mounir Ybanez on 13/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class RegistrationWireframe: RegistrationWireframeInterface {

    var root: RootWireframeInterface?
    
    required init(root: RootWireframeInterface?, view: RegistrationViewInterface) {
        self.root = root
        
        let service = AuthenticationServiceProvider()
        let intearctor = RegistrationInteractor(service: service)
        let presenter = RegistrationPresenter()

        view.presenter = presenter
        intearctor.output = presenter
        presenter.view = view
        presenter.interactor = intearctor
        presenter.wireframe = self
    }
    
    func attachRoot(with controller: UIViewController, in window: UIWindow) {
        root?.showRoot(with: controller, in: window)
    }
    
    func showErrorAlert(title: String, message: String, from controller: UIViewController?) {
        guard controller != nil else {
            return
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        controller!.present(alert, animated: true, completion: nil)
    }
}
