//
//  UserProfileInteractor.swift
//  Photostream
//
//  Created by Mounir Ybanez on 10/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

protocol UserProfileInteractorInput: BaseModuleInteractorInput {
    
    func fetchProfile(user id: String)
}

protocol UserProfileInteractorOutput: BaseModuleInteractorOutput {
    
    func userProfileDidFetch(with data: UserProfileData)
    func userProfileDidFetch(with error: UserServiceError)
}

protocol UserProfileInteractorInterface: BaseModuleInteractor {
    
    var service: UserService! { set get }
    
    init(service: UserService)
}

class UserProfileInteractor: UserProfileInteractorInterface {

    typealias Output = UserProfileInteractorOutput
    
    weak var output: Output?
    
    var service: UserService!
    
    required init(service: UserService) {
        self.service = service
    }
}

extension UserProfileInteractor: UserProfileInteractorInput {
    
    func fetchProfile(user id: String) {
        service.fetchProfile(id: id) { (result) in
            guard result.error == nil else {
                self.output?.userProfileDidFetch(with: result.error!)
                return
            }
            
            guard let profile = result.profile, let user = result.user else {
                let error: UserServiceError = .failedToFetchProfile(message: "Profile not found")
                self.output?.userProfileDidFetch(with: error)
                return
            }
            
            var item = UserProfileDataItem()
            item.id = user.id
            item.firstName = user.firstName
            item.lastName = user.lastName
            item.username = user.username
            
            item.bio = profile.bio
            item.postCount = profile.postsCount
            item.followerCount = profile.followersCount
            item.followingCount = profile.followingCount
            
            self.output?.userProfileDidFetch(with: item)
        }
    }
}
