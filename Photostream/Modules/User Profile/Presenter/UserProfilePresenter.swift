//
//  UserProfilePresenter.swift
//  Photostream
//
//  Created by Mounir Ybanez on 10/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

protocol UserProfilePresenterInterface: BaseModulePresenter, BaseModuleInteractable, BaseModuleDelegatable {
    
    var userId: String! { set get }
    var profile: UserProfileData! { set get }
}

class UserProfilePresenter: UserProfilePresenterInterface {

    typealias ModuleView = UserProfileScene
    typealias ModuleInteractor = UserProfileInteractorInput
    typealias ModuleWireframe = UserProfileWireframeInterface
    typealias ModuleDelegate = UserProfileDelegate
    
    weak var view: ModuleView!
    weak var delegate: ModuleDelegate?
    
    var interactor: ModuleInteractor!
    var wireframe: ModuleWireframe!
    
    var userId: String!
    var profile: UserProfileData!
}

extension UserProfilePresenter: UserProfileModuleInterface {
    
    func exit() {
        var property = WireframeExitProperty()
        property.controller = view.controller
        wireframe.exit(with: property)
    }
    
    func fetchUserProfile() {
        interactor.fetchProfile(user: userId)
    }
    
    func follow() {
        interactor.follow(user: userId)
    }
    
    func unfollow() {
        interactor.unfollow(user: userId)
    }
}

extension UserProfilePresenter: UserProfileInteractorOutput {

    func userProfileDidFetch(with data: UserProfileData) {
        profile = data
        view.didFetchUserProfile(with: profile)
        delegate?.userProfileDidSetupInfo()
    }
    
    func userProfileDidFetch(with error: UserServiceError) {
        view.didFetchUserProfile(with: error.message)
    }
    
    func userProfileDidFollow() {
        profile.isFollowed = true
        profile.followerCount += 1
        view.didFollow(with: profile)
        delegate?.userProfileDidFollow()
    }
    
    func userProfileDidFollow(with error: UserServiceError) {
        view.didFollow(with: error.message)
    }
    
    func userProfileDidUnfollow() {
        profile.isFollowed = false
        if profile.followerCount > 0 {
            profile.followerCount -= 1
            
        } else {
            profile.followerCount = 0
        }
        view.didUnfollow(with: profile)
        delegate?.userProfileDidUnfollow()
    }
    
    func userProfileDidUnfollow(with error: UserServiceError) {
        view.didUnfollow(with: error.message)
    }
}
