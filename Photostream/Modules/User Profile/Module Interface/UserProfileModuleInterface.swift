//
//  UserProfileModuleInterface.swift
//  Photostream
//
//  Created by Mounir Ybanez on 26/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

typealias UserProfilePostDataList = NewsFeedDataCollection
typealias UserProfilePostListItemArray = PostCellItemArray
typealias UserProfilePostGridItemArray = PostGridCellItemArray
typealias UserProfilePostDisplayItemParser = NewsFeedDisplayItemParser
typealias UserProfilePostData = NewsFeedPostData
typealias UserProfilePostAuthorData = NewsFeedUserData

protocol UserProfileModuleInterface {

    func fetchUserProfile()
    func fetchUserPosts(_ limit: Int)

    func likePost(_ postId: String)
    func unlikePost(_ postId: String)
    func showComments(_ postId: String, shouldComment: Bool)
    func showLikes(_ postId: String)
}
