//
//  NewsFeedModuleExtension.swift
//  Photostream
//
//  Created by Mounir Ybanez on 29/10/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit
import DateTools

extension NewsFeedWireframe {
    
    static var viewController: NewsFeedViewController {
        let sb = UIStoryboard(name: "NewsFeedModuleStoryboard", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "NewsFeedViewController")
        return vc as! NewsFeedViewController
    }
}

extension NewsFeedPost: PostListCellItem {
    
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
    
    var timeAgo: String {
        let date = NSDate(timeIntervalSinceNow: timestamp)
        return date.timeAgoSinceNow()
    }
}

extension NewsFeedPost: PostListHeaderItem { }
