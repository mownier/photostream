//
//  PostListCellItem.swift
//  Photostream
//
//  Created by Mounir Ybanez on 03/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

struct PostListCellItem {
    
    var postId: String?
    var message: String?
    var timestamp: Date?
    
    var photoUrl: String?
    var photoWidth: Int = 0
    var photoHeight: Int = 0
    
    var isLiked: Bool = false
    var likes: Int = 0
    
    var comments: Int = 0
    
    var userId: String?
    var displayName: String?
    var avatarUrl: String?
}

extension PostListCellItem {

    var likesText: String {
        if likes > 0 {
            if likes == 1 {
                return "1 like"
            } else {
                return "\(likes) likes"
            }
        }
        return ""
    }
    
    var commentsText: String {
        if comments > 0 {
            if comments == 1 {
                return "View 1 comment"
            } else {
                if comments > 3 {
                    return "View \(comments) comments"
                } else {
                    return "View all \(comments) comments"
                }
            }
        }
        return ""
    }
}

extension PostListCellItem: NewsFeedItem { }
