//
//  UserPostModuleExtension.swift
//  Photostream
//
//  Created by Mounir Ybanez on 06/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import DateTools

extension UserPostModule {
    
    convenience init(sceneType: UserPostSceneType = .grid) {
        let scene = UserPostViewController()
        scene.sceneType = sceneType
        self.init(view: scene)
    }
}

extension UserPostDataItem: PostGridCollectionCellItem { }

extension UserPostDataItem: PostListCollectionHeaderItem { }

extension UserPostDataItem: PostListCollectionCellItem {
    
    var timeAgo: String {
        let date = NSDate(timeIntervalSince1970: timestamp)
        return date.timeAgoSinceNow()
    }
    
    var photoSize: CGSize {
        var size = CGSize.zero
        size.width = CGFloat(photoWidth)
        size.height = CGFloat(photoHeight)
        return size
    }
    
    var likesText: String {
        guard likes > 0 else {
            return ""
        }
        
        if likes > 1 {
            return "\(likes) likes"
            
        } else {
            return "1 like"
        }
    }
    
    var commentsText: String {
        guard comments > 0 else {
            return ""
        }
        
        if comments > 1 {
            return "View \(comments) comments"
            
        } else {
            return "View 1 comment"
        }
    }
}
