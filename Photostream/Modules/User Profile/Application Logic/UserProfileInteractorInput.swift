//
//  UserProfileInteractorInput.swift
//  Photostream
//
//  Created by Mounir Ybanez on 26/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

protocol UserProfileInteractorInput {

    func fetchUserProfile()
    func fetchUserPosts(_ limit: Int)

    func likePost(_ postId: String)
    func unlikePost(_ postId: String)
}
