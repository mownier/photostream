//
//  PostCellItem.swift
//  Photostream
//
//  Created by Mounir Ybanez on 25/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

public typealias PostCellItemArray = PostCellDisplayItemArray<PostCellItem>

public protocol PostCellItemSerializer {
    
    func serializeCellItem() -> PostCellItem
}

public struct PostCellItem: PostCellDisplayItemProtocol {

    public var postId: String
    public var userId: String
    public var message: String
    public var displayName: String
    public var avatarUrl: String
    public var photoUrl: String
    public var photoWidth: Float
    public var photoHeight: Float
    public var likesCount: Int
    public var commentsCount: Int
    public var isLiked: Bool
    public var timestamp: NSDate
    public var likes: String {
        if likesCount > 0 {
            if likesCount == 1 {
                return "1 like"
            } else {
                return "\(likesCount) likes"
            }
        }
        return ""
    }
    public var comments: String {
        if commentsCount > 0 {
            if commentsCount == 1 {
                return "View 1 comment"
            } else {
                if commentsCount > 3 {
                    return "View \(commentsCount) comments"
                } else {
                    return "View all \(commentsCount) comments"
                }
            }
        }
        return ""
    }
    
    init() {
        userId = ""
        postId = ""
        message = ""
        displayName = ""
        avatarUrl = ""
        photoUrl = ""
        photoWidth = 0
        photoHeight = 0
        likesCount = 0
        commentsCount = 0
        isLiked = false
        timestamp = NSDate()
    }
    
    public mutating func updateLike(state: Bool) -> Bool{
        if isLiked != state {
            isLiked = state
            if !isLiked {
                likesCount -= 1
            } else {
                likesCount += 1
            }
            return true
        }
        return false
    }
}
