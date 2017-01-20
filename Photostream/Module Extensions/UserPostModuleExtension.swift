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
        let scene = UserPostViewController(type: sceneType)
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

extension UserPostScene {
    
    func assignScrollEventListener(listener: ScrollEventListener) {
        guard let controller = self as? UserPostViewController else {
            return
        }
        
        controller.scrollEventListener = listener
    }
    
    func assignSceneType(type: UserPostSceneType) {
        guard let controller = self as? UserPostViewController else {
            return
        }
        
        controller.sceneType = type
    }
    
    func killScroll() {
        guard let controller = self as? UserPostViewController else {
            return
        }
        
        controller.scrollHandler.killScroll()
    }
    
    func assignContent(offset: CGPoint) {
        guard let controller = self as? UserPostViewController else {
            return
        }
        
        controller.collectionView!.setContentOffset(offset, animated: false)
    }

    func assignRefreshEventTarget(target: Any, action: Selector) {
        guard let controller = self as? UserPostViewController else {
            return
        }
        
        controller.refreshView.addTarget(target, action: action, for: .valueChanged)
    }
}

extension UserPostWireframeInterface {
    
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

extension UserPostModuleInterface {
    
    func presentCommentController(at index: Int, shouldComment: Bool = false) {
        guard let presenter = self as? UserPostPresenter,
            let parent = presenter.view.controller,
            let post = post(at: index) else {
            return
        }
        
        presenter.wireframe.presentCommentController(from: parent, delegate: presenter, postId: post.id, shouldComment: shouldComment)
    }
    
    func presentPostLikes(at index: Int) {
        guard let presenter = self as? UserPostPresenter,
            let parent = presenter.view.controller,
            let post = post(at: index) else {
                return
        }
        
        presenter.wireframe.showPostLikes(from: parent, postId: post.id)
    }
}

extension UserPostPresenter: CommentControllerDelegate {
    
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

