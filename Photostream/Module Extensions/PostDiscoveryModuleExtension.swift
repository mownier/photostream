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
    
    func showPostDiscovery(from parent: UIViewController, type: PostDiscoverySceneType, posts: [PostDiscoveryData] = [PostDiscoveryData]()) {
        let module = PostDiscoveryModule(sceneType: type)
        module.build(root: root)
        
        var property = WireframeEntryProperty()
        property.controller = module.view.controller
        property.parent = parent
        
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
    
    func presentPostDiscovery(type: PostDiscoverySceneType = .list) {
        guard let presenter = self as? PostDiscoveryPresenter,
            let parent = presenter.view.controller else {
                return
        }
        
        presenter.wireframe.showPostDiscovery(from: parent, type: type, posts: presenter.posts)
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
