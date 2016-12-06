//
//  UserProfileInteractor.swift
//  Photostream
//
//  Created by Mounir Ybanez on 26/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation
import FirebaseAuth

class UserProfileInteractor: UserProfileInteractorInput {

    var output: UserProfileInteractorOutput!
    var service: UserProfileService!
    var postService: PostService!
    var userId: String!

    init(service: UserProfileService, userId: String?) {
        self.service = service
        if userId != nil {
            self.userId = userId
        } else {
            self.userId = FIRAuth.auth()?.currentUser?.uid
        }
    }

    func fetchUserProfile() {
        service.user.fetchProfile(id: userId) { (result) in
            if let error = result.error {
                self.output.userProfileDidFetchWithError(error)
            } else {
                let data = self.parseUserProfileData(result)
                self.output.userProfileDidFetchOk(data)
            }
        }
    }

    func fetchUserPosts(_ limit: Int) {
        service.post.fetchPosts(userId: userId, offset: "", limit: 10) { (result) in
            guard result.error == nil  else {
                self.output.userProfileDidFetchPostsWithError(result.error!)
                return
            }
            
            let data = self.parseUserPostDataList(result.posts)
            self.output.userProfileDidFetchPostsOk(data)
        }
    }

    func likePost(_ postId: String) {

    }

    func unlikePost(_ postId: String) {

    }

    fileprivate func parseUserProfileData(_ result: UserServiceProfileResult) -> UserProfileData {
        var data = UserProfileData()
        data.followersCount = result.profile!.followersCount
        data.followingCount = result.profile!.followingCount
        data.postsCount = result.profile!.postsCount
        data.avatarUrl = result.user!.avatarUrl
        data.fullName = result.user!.fullName
        data.userId = result.user!.id
        data.username = result.user!.username
        data.bio = result.profile!.bio
        return data
    }

    fileprivate func parseUserPostDataList(_ posts: PostList?) -> UserProfilePostDataList {
        guard posts != nil else {
            return UserProfilePostDataList()
        }
        
        let data = UserProfilePostDataList()
//        for i in 0..<posts!.count {
//            if let (post, user) = posts![i] {
//                var postItem = UserProfilePostData()
//                postItem.message = post.message
//                postItem.id = post.id
//                postItem.comments = post.commentsCount
//                postItem.likes = post.likesCount
//                postItem.isLiked = post.isLiked
//                postItem.timestamp = post.timestamp / 1000
//                postItem.userId = user.id
//                postItem.photoUrl = post.photo.url
//                postItem.photoWidth = post.photo.width
//                postItem.photoHeight  = post.photo.height
//
//                var userItem = UserProfilePostAuthorData()
//                userItem.userId = user.id
//                userItem.avatarUrl = user.avatarUrl
//                userItem.displayName = user.displayName
//
//                data.add(postItem, userItem: userItem)
//            }
//        }
        return data
    }
}
