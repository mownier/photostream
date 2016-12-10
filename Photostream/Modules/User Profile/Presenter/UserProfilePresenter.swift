//
//  UserProfilePresenter.swift
//  Photostream
//
//  Created by Mounir Ybanez on 10/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

protocol UserProfilePresenterInterface: BaseModulePresenter, BaseModuleInteractable {
    
    var userId: String! { set get }
}

class UserProfilePresenter: UserProfilePresenterInterface {

    typealias ModuleView = UserProfileScene
    typealias ModuleInteractor = UserProfileInteractorInput
    typealias ModuleWireframe = UserProfileWireframeInterface
    
    weak var view: ModuleView!
    
    var interactor: ModuleInteractor!
    var wireframe: ModuleWireframe!
    var userId: String!
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
}

extension UserProfilePresenter: UserProfileInteractorOutput {

    func userProfileDidFetch(with data: UserProfileData) {
        view.didFetchUserProfile(with: data)
    }
    
    func userProfileDidFetch(with error: UserServiceError) {
        view.didFetchUserProfile(with: error.message)
    }
}
