//
//  UserProfileInteractor.swift
//  Photostream
//
//  Created by Mounir Ybanez on 26/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

class UserProfileInteractor: UserProfileInteractorInput {

    var output: UserProfileInteractorOutput!
    var service: UserService!
    
    init(service: UserService) {
        self.service = service
    }
    
    func fetchUserProfile(userId: String) {
        service.fetchProfile(userId) { (result, error) in
            if let error = error {
                self.output.userProfileDidFetchWithError(error)
            } else {
                let data = self.parseUserProfileData(result!)
                self.output.userProfileDidFetchOk(data)
            }
        }
    }
    
    private func parseUserProfileData(result: UserServiceProfileResult) -> UserProfileData {
        var data = UserProfileData()
        data.followersCount = result.profile.followersCount
        data.followingCount = result.profile.followingCount
        data.postsCount = result.profile.postsCount
        data.avatarUrl = result.user.avatarUrl
        data.fullName = result.user.fullName
        data.userId = result.user.id
        data.username = result.user.username
        return data
    }
}
