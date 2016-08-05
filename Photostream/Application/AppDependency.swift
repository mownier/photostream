//
//  AppDependency.swift
//  Photostream
//
//  Created by Mounir Ybanez on 03/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

class AppDependency: AnyObject, LoginInteractorOutput {

    init() {
        let source = LoginAPIFirebase()
        let service = LoginService(source: source)
        let interactor = LoginInteractor(service: service)
        interactor.output = self
        interactor.login("chika@chikaminute.com", password: "123456789")
    }

    func loginDidSucceed(user: User!) {
        print(user)
    }

    func loginDidFail(error: NSError!) {
        print(error)
    }
}
