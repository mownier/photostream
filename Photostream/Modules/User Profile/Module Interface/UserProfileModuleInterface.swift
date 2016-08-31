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
    func fetchUserPosts(limit: Int)

    func likePost(postId: String)
    func unlikePost(postId: String)
    func showComments(postId: String, shouldComment: Bool)
    func showLikes(postId: String)
}
