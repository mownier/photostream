//
//  UserProfileWireframe.swift
//  Photostream
//
//  Created by Mounir Ybanez on 26/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class UserProfileWireframe: AnyObject {

    weak var userProfileViewController: UserProfileViewController!
    var userProfilePresenter: UserProfilePresenter!
    var rootWireframe: RootWireframe!

    init(userId: String) {
        let session = AuthSession()
        let user = UserAPIFirebase(session: session)
        let post = PostAPIFirebase(session: session)
        let service = UserProfileService(user: user, post: post)
        let interactor = UserProfileInteractor(service: service, userId: userId)
        let presenter = UserProfilePresenter()
        interactor.output = presenter
        presenter.interactor = interactor
        presenter.wireframe = self

        self.userProfilePresenter = presenter
    }

    func navigateCommentsInterface(_ postId: String, shouldComment: Bool) {

    }

    func navigateLikesInterface(_ postId: String) {

    }
}
