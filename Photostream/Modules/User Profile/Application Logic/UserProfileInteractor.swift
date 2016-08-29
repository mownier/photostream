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
    var service: UserProfileService!
    var postService: PostService!
    var userId: String!
    
    init(service: UserProfileService, userId: String) {
        self.service = service
        self.userId = userId
    }
    
    func fetchUserProfile() {
        service.user.fetchProfile(userId) { (result, error) in
            if let error = error {
                self.output.userProfileDidFetchWithError(error)
            } else {
                let data = self.parseUserProfileData(result!)
                self.output.userProfileDidFetchOk(data)
            }
        }
    }
    
    func fetchUserPosts(limit: Int) {
        service.post.fetchPosts(userId, offset: 0, limit: 10) { (result, error) in
            if let error = error {
                self.output.userProfileDidFetchPostsWithError(error)
            } else {
                let data = self.parseUserPostDataList(result)
                self.output.userProfileDidFetchPostsOk(data)
            }
        }
    }
    
    func likePost(postId: String) {
        
    }
    
    func unlikePost(postId: String) {
        
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
        data.bio = result.profile.bio
        return data
    }
    
    private func parseUserPostDataList(feed: PostServiceResult!) -> UserProfilePostDataList {
        var data = UserProfilePostDataList()
        
        for i in 0..<feed.count {
            if let (post, user) = feed[i] {
                var postItem = UserProfilePostData()
                postItem.message = post.message
                postItem.postId = post.id
                postItem.commentsCount = post.commentsCount
                postItem.likesCount = post.likesCount
                postItem.isLiked = post.isLiked
                postItem.timestamp = post.timestamp / 1000
                postItem.userId = user.id
                postItem.photoUrl = post.photo.url
                postItem.photoWidth = post.photo.width
                postItem.photoHeight  = post.photo.height
                
                var userItem = UserProfilePostAuthorData()
                userItem.userId = user.id
                userItem.avatarUrl = user.avatarUrl
                userItem.displayName = user.displayName
                
                data.add(postItem, userItem: userItem)
            }
        }
        
        return data
    }
}
