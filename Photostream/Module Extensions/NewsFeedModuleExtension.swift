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
    
    func showUserTimeline(from parent: UIViewController?, userId: String) {
        let userTimeline = UserTimelineViewController()
        userTimeline.root = root
        userTimeline.style = .push
        userTimeline.userId = userId
        
        var property = WireframeEntryProperty()
        property.parent = parent
        property.controller = userTimeline
        
        userTimeline.enter(with: property)
    }
    
    func showPostLikes(from parent: UIViewController?, postId: String) {
        let module = PostLikeModule()
        module.build(root: root, postId: postId)
        
        var property = WireframeEntryProperty()
        property.parent = parent
        property.controller = module.view.controller
        
        module.wireframe.style = .push
        module.wireframe.enter(with: property)
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
    
    func presentUserTimeline(at index: Int) {
        guard let presenter = self as? NewsFeedPresenter,
            let parent = presenter.view.controller,
            let post = feed(at: index) as? NewsFeedPost else {
            return
        }
        
        presenter.wireframe.showUserTimeline(from: parent, userId: post.userId)
    }
    
    func presentPostLikes(at index: Int) {
        guard let presenter = self as? NewsFeedPresenter,
            let parent = presenter.view.controller,
            let post = feed(at: index) as? NewsFeedPost else {
                return
        }
        
        presenter.wireframe.showPostLikes(from: parent, postId: post.id)
    }
}

extension NewsFeedPost: PostListCollectionCellItem {
    
    var photoSize: CGSize {
        var size = CGSize.zero
        size.width = CGFloat(photoWidth)
        size.height = CGFloat(photoHeight)
        return size
    }
    
    var timeAgo: String {
        let date = NSDate(timeIntervalSince1970: timestamp)
        return date.timeAgoSinceNow()
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

extension NewsFeedPost: PostListCollectionHeaderItem { }

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
