//
//  UserProfileModuleExtension.swift
//  Photostream
//
//  Created by Mounir Ybanez on 10/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

extension UserProfileModule {
    
    convenience init() {
        self.init(view: UserProfileViewController())
    }
}

extension UserProfileDataItem: UserProfileViewItem {
    
    var postCountText: String {
        return "\(postCount)"
    }
    
    var followerCountText: String {
        return "\(followerCount)"
    }
    
    var followingCountText: String {
        return "\(followingCount)"
    }
    
    var isMe: Bool {
        let session = AuthSession()
        return session.user.id == id
    }
}

extension UserProfileModuleInterface {
    
    func presentProfileEdit() {
        guard let presenter = self as? UserProfilePresenter else {
            return
        }
        
        var data = ProfileEditDataItem()
        data.avatarUrl = presenter.profile.avatarUrl
        data.username = presenter.profile.username
        data.bio = presenter.profile.bio
        data.firstName = presenter.profile.firstName
        data.lastName = presenter.profile.lastName
        
        presenter.wireframe.showProfileEdit(from: presenter.view.controller, data: data)
    }
}

extension UserProfileWireframeInterface {
    
    func showProfileEdit(from parent: UIViewController?, data: ProfileEditData) {
        let module = ProfileEditModule()
        module.build(root: root, data: data)
        
        var property = WireframeEntryProperty()
        property.parent = parent
        property.controller = module.view.controller
        
        module.wireframe.style = .push
        module.wireframe.enter(with: property)
    }
}
