//
//  UserPostModuleExtension.swift
//  Photostream
//
//  Created by Mounir Ybanez on 06/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import DateTools

enum UserPostSceneType {
    case grid
    case list
}

extension UserPostModule {
    
    convenience init(sceneType: UserPostSceneType) {
        switch sceneType {
        case .grid:
            self.init(view: UserPostGridViewController())
        case .list:
            self.init(view: UserPostListViewController())
        }
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
