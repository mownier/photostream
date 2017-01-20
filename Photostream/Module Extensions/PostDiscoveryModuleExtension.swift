//
//  PostDiscoveryModuleExtension.swift
//  Photostream
//
//  Created by Mounir Ybanez on 20/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import DateTools

extension PostDiscoveryModule {
    
    convenience init(sceneType: PostDiscoverySceneType = .grid) {
        let scene = PostDiscoveryViewController(type: sceneType)
        self.init(view: scene)
    }
}

extension PostDiscoveryScene {
    
    func isBackBarItemVisible(_ isVisible: Bool) {
        guard let controller = controller as? PostDiscoveryViewController else {
            return
        }
        
        controller.isBackBarItemVisible = isVisible
    }
}

extension PostDiscoveryWireframeInterface {
    
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
    
    func showPostDiscoveryAsList(from parent: UIViewController, posts: [PostDiscoveryData] = [PostDiscoveryData](), index: Int) {
        let module = PostDiscoveryModule(sceneType: .list)
        module.build(
            root: root,
            posts: posts,
            initialPostIndex: index
        )
        module.view.isBackBarItemVisible(true)
        
        var property = WireframeEntryProperty()
        property.controller = module.view.controller
        property.parent = parent
        
        module.wireframe.style = .push
        module.wireframe.enter(with: property)
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

extension PostDiscoveryModuleInterface {
    
    func presentCommentController(at index: Int, shouldComment: Bool = false) {
        guard let presenter = self as? PostDiscoveryPresenter,
            let parent = presenter.view.controller,
            let post = post(at: index) else {
                return
        }
        
        presenter.wireframe.presentCommentController(from: parent, delegate: presenter, postId: post.id, shouldComment: shouldComment)
    }
    
    func presentPostDiscoveryAsList(with index: Int) {
        guard let presenter = self as? PostDiscoveryPresenter,
            let parent = presenter.view.controller else {
                return
        }
        
        presenter.wireframe.showPostDiscoveryAsList(
            from: parent,
            posts: presenter.posts,
            index: index
        )
    }
    
    func presentUserTimeline(at index: Int) {
        guard let presenter = self as? PostDiscoveryPresenter,
            let parent = presenter.view.controller,
            let post = post(at: index) else {
                return
        }
        
        presenter.wireframe.showUserTimeline(from: parent, userId: post.userId)
    }
    
    func presentPostLikes(at index: Int) {
        guard let presenter = self as? NewsFeedPresenter,
            let parent = presenter.view.controller,
            let post = post(at: index) else {
                return
        }
        
        presenter.wireframe.showPostLikes(from: parent, postId: post.id)
    }
}

extension PostDiscoveryPresenter: CommentControllerDelegate {
    
    func commentControllerDidWrite(with postId: String) {
        guard let index = indexOf(post: postId) else {
            return
        }
        
        var post = posts[index]
        post.comments += 1
        posts[index] = post
        view.reloadView()
    }
}

extension PostDiscoveryDataItem: PostGridCollectionCellItem { }

extension PostDiscoveryDataItem: PostListCollectionHeaderItem { }

extension PostDiscoveryDataItem: PostListCollectionCellItem {
    
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
