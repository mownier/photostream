//
//  UserProfilePresenter.swift
//  Photostream
//
//  Created by Mounir Ybanez on 26/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class UserProfilePresenter: UserProfileModuleInterface, UserProfileInteractorOutput {

    var view: UserProfileViewInterface!
    var interactor: UserProfileInteractorInput!
    var wireframe: UserProfileWireframe!

    func fetchUserProfile() {
        interactor.fetchUserProfile()
    }

    func fetchUserPosts(limit: Int) {
        interactor.fetchUserPosts(limit)
    }

    func likePost(postId: String) {
        interactor.likePost(postId)
    }

    func unlikePost(postId: String) {
        interactor.unlikePost(postId)
    }

    func showComments(postId: String, shouldComment: Bool) {
        wireframe.navigateCommentsInterface(postId, shouldComment: shouldComment)
    }

    func showLikes(postId: String) {
        wireframe.navigateLikesInterface(postId)
    }

    func userProfileDidFetchOk(data: UserProfileData) {
        let item = serialize(data)
        view.showUserProfile(item)
    }

    func userProfileDidFetchWithError(error: NSError) {
        view.showError(error)
    }

    func userProfileDidFetchPostsOk(data: UserProfilePostDataList) {
        let (list, grid) = parseList(data)
        view.showUserPosts(list, grid: grid)
        view.reloadUserPosts()
    }

    func userProfileDidFetchPostsWithError(error: NSError) {
        view.showError(error)
    }

    private func serialize(data: UserProfileData) -> UserProfileDisplayItem {
        var item = UserProfileDisplayItem()
        item.avatarUrl = data.avatarUrl
        item.bio = data.bio
        item.displayName = data.fullName
        item.username = data.username
        item.followersCountText = "\(data.followersCount)"
        item.followingCountText = "\(data.followingCount)"
        item.postsCountText = "\(data.postsCount)"
        return item
    }

    private func parseList(data: UserProfilePostDataList) -> (UserProfilePostListItemArray, UserProfilePostGridItemArray) {
        var list = UserProfilePostListItemArray()
        var grid = UserProfilePostGridItemArray()
        for i in 0..<data.count {
            if let (post, user) = data[i] {
                let parser = UserProfilePostDisplayItemParser(post: post, user: user)
                let listItem =  parser.serializeCellItem()
                list.append(listItem)

                var gridItem = PostGridCellItem()
                gridItem.postId = post.postId
                gridItem.photoUrl = post.photoUrl
                grid.append(gridItem)
            }
        }
        return (list, grid)
    }
}
