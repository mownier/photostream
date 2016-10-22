//
//  UserProfileViewInterface.swift
//  Photostream
//
//  Created by Mounir Ybanez on 27/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

protocol UserProfileViewInterface {

    func showError(_ message: String)
    func showUserProfile(_ item: UserProfileDisplayItem)

    func reloadUserPosts()
    func showUserPosts(_ list: UserProfilePostListItemArray, grid: UserProfilePostGridItemArray)
}
