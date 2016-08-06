//
//  AppDependency.swift
//  Photostream
//
//  Created by Mounir Ybanez on 03/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

class AppDependency: AnyObject, RegistrationInteractorOutput, LoginInteractorOutput {

    init() {
        login()
    }
    
    func login() {
        let source = AuthenticationAPIFirebase()
        let service = AuthenticationService(source: source)
        let interactor = LoginInteractor(service: service)
        interactor.output = self
        interactor.login("redrepo.mail@gmail.com", password: "mynameisred")
    }
    
    func register() {
        let source = AuthenticationAPIFirebase()
        let service = AuthenticationService(source: source)
        let interactor = RegistrationInteractor(service: service)
        interactor.output = self
        interactor.register("redrepo.mail@gmail.com", password: "mynameisred", firstname: "Red", lastname: "Repo")
    }

    func registrationDidSucceed(user: User!) {
        print("registration succeeded: ", user)
    }
    
    func registrationDidFail(error: NSError!) {
        print("registration failed: ", error)
    }
    
    func loginDidSucceed(user: User!) {
        print("login succeeded: ", user)
    }
    
    func loginDidFail(error: NSError!) {
        print("login failed: ", error)
    }
}
