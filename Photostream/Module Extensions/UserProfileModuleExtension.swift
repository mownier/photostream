//
//  UserProfileModuleExtension.swift
//  Photostream
//
//  Created by Mounir Ybanez on 10/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

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
