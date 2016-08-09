//
//  AppDependency.swift
//  Photostream
//
//  Created by Mounir Ybanez on 03/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation
import FirebaseAuth

class AppDependency: AnyObject, RegistrationInteractorOutput, LoginInteractorOutput {

    
    var user = FIRAuth.auth()?.currentUser
    
    init() {
        getComments("-KOhu7qXwkjI_lGNY4Pj")
    }
    
    func getMePosts() {
        let source = PostAPIFirebase()
        let service = PostService(source: source)
        if let user = user {
            service.get(user.uid, offset: 0, limit: 10) { (posts, error) in
                print("posts:", posts)
                print("error:", error)
            }
        }
    }
    
    func post() {
        let source = PostAPIFirebase()
        let service = PostService(source: source)
        if let user = user {
            let imageUrl = "http://imageurl.png"
            var poster = User()
            poster.id = user.uid
            service.post(imageUrl, user: poster) { (posts, error) in
                print("posts:", posts)
                print("error:", error)
            }
        }
    }
    
    func getComments(pid: String!) {
        let source = CommentAPIFirebase()
        let service = CommentService(source: source)
        if let _ = user {
            service.get(pid, offset: 0, limit: 10) { (comments, error) in
                print("comments:", comments)
                print("error:", error)
            }
        }
    }
    
    func comment(pid: String!) {
        let source = CommentAPIFirebase()
        let service = CommentService(source: source)
        if let user = user {
            let message = "Hello world!"
            var commenter = User()
            commenter.id = user.uid
            service.post(pid, message: message, user: commenter) { (comments, error) in
                print("comments:", comments)
                print("error:", error)
            }
        }
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
