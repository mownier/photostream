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

extension NewsFeedWireframeInterface {
    
    func presentCommentController(from parent: UIViewController, delegate: CommentControllerDelegate?, postId: String, shouldComment: Bool = false) {
        let controller = CommentController(root: nil)
        controller.postId = postId
        controller.style = .push
        controller.shouldComment = shouldComment
        controller.delegate = delegate
        
        var property = WireframeEntryProperty()
        property.controller = controller
        property.parent = parent
        
        controller.enter(with: property)
    }
}

extension NewsFeedModuleInterface {
    
    func presentCommentController(at index: Int, shouldComment: Bool = false) {
        guard let presenter = self as? NewsFeedPresenter,
            let parent = presenter.view.controller,
            let post = feed(at: index) as? NewsFeedPost else {
            return
        }
        
        presenter.wireframe.presentCommentController(from: parent, delegate: presenter, postId: post.id, shouldComment: shouldComment)
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

extension NewsFeedPresenter: HomeModuleDependency { }

extension NewsFeedPresenter: CommentControllerDelegate {
    
    func commentControllerDidWrite(with postId: String) {
        guard let index = feed.indexOf(post: postId),
            var post = feed.items[index] as? NewsFeedPost else {
            return
        }
        
        post.comments += 1
        feed.items[index] = post
        view.reloadView()
    }
}
