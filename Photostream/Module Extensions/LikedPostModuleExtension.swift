//
//  LikedPostModuleExtension.swift
//  Photostream
//
//  Created by Mounir Ybanez on 19/01/2017.
//  Copyright © 2017 Mounir Ybanez. All rights reserved.
//

import UIKit

extension LikedPostModule {
    
    convenience init() {
        self.init(view: LikedPostViewController())
    }
}

extension LikedPostDataItem: PostListCollectionHeaderItem { }

extension LikedPostDataItem: PostListCollectionCellItem {
    
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

extension LikedPostWireframeInterface {
    
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

extension LikedPostModuleInterface {
    
    func presentCommentController(at index: Int, shouldComment: Bool = false) {
        guard let presenter = self as? LikedPostPresenter,
            let parent = presenter.view.controller,
            let post = post(at: index) else {
                return
        }
        
        presenter.wireframe.presentCommentController(
            from: parent,
            delegate: presenter,
            postId: post.id,
            shouldComment: shouldComment
        )
    }
    
    func presentUserTimeline(at index: Int) {
        guard let presenter = self as? LikedPostPresenter,
            let parent = presenter.view.controller,
            let post = post(at: index) else {
                return
        }
        
        presenter.wireframe.showUserTimeline(from: parent, userId: post.userId)
    }
    
    func presentPostLikes(at index: Int) {
        guard let presenter = self as? LikedPostPresenter,
            let parent = presenter.view.controller,
            let post = post(at: index) else {
                return
        }
        
        presenter.wireframe.showPostLikes(from: parent, postId: post.id)
    }
}

extension LikedPostPresenter: CommentControllerDelegate {
    
    func commentControllerDidWrite(with postId: String) {
        guard let index = indexOf(post: postId),
            var post = post(at: index) else {
            return
        }
        
        post.comments += 1
        posts[index] = post
        
        view.reload(at: index)
    }
}
