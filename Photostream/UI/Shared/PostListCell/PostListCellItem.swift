//
//  PostListCellItem.swift
//  Photostream
//
//  Created by Mounir Ybanez on 03/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

protocol PostListCellItem {
    
    var message: String { get }
    var displayName: String { get }
    var avatarUrl: String { get }
    var photoUrl: String { get }
    var timeAgo: String { get }
    var isLiked: Bool { get }
    var likesText: String { get }
    var commentsText: String { get }
}

extension PostListCell {
    
    func configure(for item: PostListCellItem, isPrototype: Bool = false) {
        if !isPrototype {
            setPhoto(with: item.photoUrl)
        }
        
        setMessage(with: item.message, and: item.displayName)
        elapsedTime = item.timeAgo
        
        shouldHighlightLikeButton(item.isLiked)
        likesCountText = item.likesText
        commentsCountText = item.commentsText
    }
    
    func dynamicHeight(for item: PostListCellItem, with maxWidth: CGFloat, and photoSize: CGSize) -> CGFloat {
        configure(for: item)
        
        bounds = CGRect(x: 0, y: 0, width: maxWidth, height: bounds.height)
        setNeedsLayout()
        layoutIfNeeded()
        sizeToFit()
        
        var height = kPostCellInitialHeight
        
        if item.likesText.isEmpty {
            height -= (kPostCellCommonTop + kPostCellCommonHeight)
        }
        
        if item.commentsText.isEmpty {
            height -= (kPostCellCommonTop + kPostCellCommonHeight)
        }
        
        height -= (kPostCellCommonTop + kPostCellCommonHeight)
        
        if !item.message.isEmpty {
            height += messageLabel.intrinsicContentSize.height
        }
        
        height -= kPostCellInitialPhotoHeight
        
        let ratio = maxWidth / CGFloat(photoSize.width)
        let photoHeight = CGFloat(photoSize.height) * ratio
        
        let result = height + photoHeight
        
        return result
    }
}
