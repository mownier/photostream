//
//  FeatureTests.swift
//  Photostream
//
//  Created by Mounir Ybanez on 13/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation
import FirebaseAuth

/*
 pw: mynameiswee
 User(id: "GtcQ2qoLnvh8MtjI1JmiN1vxdh82", username: nil, firstName: "Wee", lastName: "Wee", email: "wee@wee.com")

 pw: mynameisred
 User(id: "KptguGieRWRBUEL8VCQIcsM9UC92", username: nil, firstName: "Red", lastName: "Repo", email: "redrepo.mail@gmail.com")
 */
class FeatureTests: RegistrationInteractorOutput, LoginInteractorOutput {

    var user = FIRAuth.auth()?.currentUser

    init() {

    }

    func loginWee() {
        login("wee@wee.com", "mynameiswee")
    }

    func loginRed() {
        login("redrepo.mail@gmail.com", "mynameisred")
    }

    func fetchLikes(_ postId: String) {
        if let user = user {
            var u = User()
            u.id = user.uid

            var session = AuthSession()
            session.user = u

            let service = PostServiceProvider(session: session)
            service.fetchLikes(postId, offset: 0, limit: 10, callback: { (likes, error) in
                print("likes:", likes)
                print("error:", error)
            })
        }
    }

    func likePost(_ postId: String!) {
        if let user = user {
            var u = User()
            u.id = user.uid

            var session = AuthSession()
            session.user = u

            let service = PostServiceProvider(session: session)
            service.like(postId, callback: { (ok, error) in
                print("ok like?:", ok)
                print("error:", error)
            })
        }
    }

    func unlikePost(_ postId: String!) {
        if let user = user {
            var u = User()
            u.id = user.uid

            var session = AuthSession()
            session.user = u

            let service = PostServiceProvider(session: session)
            service.unlike(postId, callback: { (ok, error) in
                print("ok unlike?:", ok)
                print("error:", error)
            })
        }
    }

    func fetchProfile() {
        if let user = user {
            var u = User()
            u.id = user.uid

            var session = AuthSession()
            session.user = u

            let service = UserServiceProvider(session: session)
            service.fetchProfile(u.id, callback: { (result, error) in
                print("profile:", result)
                print("error:", error)
            })
        }
    }

    func fetchFollowing() {
        if let user = user {
            var u = User()
            u.id = user.uid

            var session = AuthSession()
            session.user = u

            let service = UserServiceProvider(session: session)
            service.fetchFollowing(u.id, offset: 0, limit: 10, callback: { (following, error) in
                print("following:", following)
                print("error:", error)
            })
        }
    }

    func fetchFollowers() {
        if let user = user {
            var u = User()
            u.id = user.uid

            var session = AuthSession()
            session.user = u

            let service = UserServiceProvider(session: session)
            service.fetchFollowers(u.id, offset: 0, limit: 10, callback: { (followers, error) in
                print("followers:", followers)
                print("error:", error)
            })
        }
    }

    func unfollow(_ userId: String!) {
        if let user = user {
            var u = User()
            u.id = user.uid

            var session = AuthSession()
            session.user = u

            let service = UserServiceProvider(session: session)
            service.unfollow(userId, callback: { (users, error) in
                print("unfollowed user:", users)
                print("error:", error)
            })
        }
    }

    func follow(_ userId: String!) {
        if let user = user {
            var u = User()
            u.id = user.uid

            var session = AuthSession()
            session.user = u

            let service = UserServiceProvider(session: session)
            service.follow(userId, callback: { (users, error) in
                print("followed user:", users)
                print("error:", error)
            })
        }
    }

    func getMePosts() {
        if let user = user {
            var u = User()
            u.id = user.uid

            var session = AuthSession()
            session.user = u

            let service = PostServiceProvider(session: session)
            service.fetchPosts(u.id, offset: 0, limit: 10) { (posts, error) in
                print("posts:", posts)
                print("error:", error)
            }
        }
    }

    func post() {
        if let user = user {
            var u = User()
            u.id = user.uid

            var session = AuthSession()
            session.user = u

            let service = PostServiceProvider(session: session)
            let imageUrl = "http://imageurl.png"
            service.writePost(imageUrl) { (posts, error) in
                print("posts:", posts)
                print("error:", error)
            }
        }
    }

    func getComments(_ pid: String!) {
        if let user = user {
            var u = User()
            u.id = user.uid

            var session = AuthSession()
            session.user = u

            let service = CommentServiceProvider(session: session)
            service.fetchComments(pid, offset: 0, limit: 10) { (comments, error) in
                print("comments:", comments)
                print("error:", error)
            }
        }
    }

    func comment(_ pid: String!) {
        if let user = user {
            var u = User()
            u.id = user.uid

            var session = AuthSession()
            session.user = u

            let service = CommentServiceProvider(session: session)
            let message = "Hello world!"
            service.writeComment(pid, message: message) { (comments, error) in
                print("comments:", comments)
                print("error:", error)
            }
        }
    }

    func login(_ email: String!, _ password: String!) {
        let service = AuthenticationServiceProvider()
        let interactor = LoginInteractor(service: service)
        interactor.output = self
        // interactor.login("redrepo.mail@gmail.com", password: "mynameisred")
        interactor.login(email, password: password)
    }

    func register(_ email: String!, _ password: String!, _ firstname: String!, _ lastname: String!) {
        let service = AuthenticationServiceProvider()
        let interactor = RegistrationInteractor(service: service)
        interactor.output = self
        // interactor.register("redrepo.mail@gmail.com", password: "mynameisred", firstname: "Red", lastname: "Repo")
        interactor.register(email, password: password, firstname: firstname, lastname: lastname)
    }

    func registrationDidSucceed(_ user: User!) {
        print("registration succeeded: ", user)
    }

    func registrationDidFail(_ error: AuthenticationServiceError) {
        print("registration failed: ", error)
    }

    func loginDidSucceed(_ user: User!) {
        print("login succeeded: ", user)
    }

    func loginDidFail(_ error: AuthenticationServiceError) {
        print("login failed: ", error)
    }
}
