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
        
        presenter.wireframe.showProfileEdit(from: presenter.view.controller, data: data, delegate: presenter)
    }
    
    func presentFollowers() {
        presentFollowList(fetchType: .followers)
    }
    
    func presentFollowing() {
        presentFollowList(fetchType: .following)
    }
    
    fileprivate func presentFollowList(fetchType: FollowListFetchType) {
        guard let presenter = self as? UserProfilePresenter else {
            return
        }
        
        let parent = presenter.view.controller
        presenter.wireframe.showFollowList(
            from: parent,
            userId: presenter.userId,
            fetchType: fetchType,
            delegate: presenter)
    }
}

extension UserProfileWireframeInterface {
    
    func showProfileEdit(from parent: UIViewController?, data: ProfileEditData, delegate: ProfileEditDelegate? = nil) {
        let module = ProfileEditModule()
        module.build(root: root, data: data, delegate: delegate)
        
        var property = WireframeEntryProperty()
        property.parent = parent
        property.controller = module.view.controller
        
        module.wireframe.style = .push
        module.wireframe.enter(with: property)
    }
    
    func showFollowList(from parent: UIViewController?, userId: String, fetchType: FollowListFetchType, delegate: FollowListDelegate? = nil) {
        let module = FollowListModule()
        module.build(root: root, userId: userId, fetchType: fetchType, delegate: delegate)
        
        var property = WireframeEntryProperty()
        property.parent = parent
        property.controller = module.view.controller
        
        module.wireframe.style = .push
        module.wireframe.enter(with: property)
    }
}

extension UserProfilePresenter: ProfileEditDelegate {
    
    func profileEditDidUpdate(data: ProfileEditData) {
        if !data.avatarUrl.isEmpty, profile.avatarUrl != data.avatarUrl {
            profile.avatarUrl = data.avatarUrl
        }
        
        if !data.username.isEmpty, profile.username != data.username  {
            profile.username = data.username
        }
        
        if !data.bio.isEmpty, profile.bio != data.bio {
            profile.bio = data.bio
        }
        
        if !data.firstName.isEmpty, profile.firstName != data.firstName {
            profile.firstName = data.firstName
        }
        
        if !data.lastName.isEmpty, profile.lastName != data.lastName {
            profile.lastName = data.lastName
        }
        
        view.didFetchUserProfile(with: profile)
        delegate?.userProfileDidSetupInfo()
    }
}

extension UserProfilePresenter: FollowListDelegate {
    
    func followListDidFollow(isMe: Bool) {
        guard isMe else {
            return
        }
        
        profile.followingCount += 1
        
        view.didFetchUserProfile(with: profile)
        delegate?.userProfileDidSetupInfo()
    }
    
    func followListDidUnfollow(isMe: Bool) {
        guard isMe else {
            return
        }
        
        let newCount = profile.followingCount - 1
        if newCount < 0  {
            profile.followingCount = 0
            
        } else {
            profile.followingCount = newCount
        }
        
        view.didFetchUserProfile(with: profile)
        delegate?.userProfileDidSetupInfo()
    }
}
