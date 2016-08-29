//
//  UserProfileService.swift
//  Photostream
//
//  Created by Mounir Ybanez on 27/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

struct UserProfileService {

    var user: UserService
    var post: PostService
    
    init(user: UserService, post: PostService) {
        self.user = user
        self.post = post
    }
}
