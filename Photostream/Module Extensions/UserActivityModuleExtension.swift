//
//  UserActivityModuleExtension.swift
//  Photostream
//
//  Created by Mounir Ybanez on 23/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

extension UserActivityModule {
    
    convenience init() {
        self.init(view: UserActivityViewController())
    }
}

extension UserActivityLikeDataItem: ActivityTableCellLikeItem {
    
    var content: String {
        return "\(displayName) liked your photo."
    }
}

extension UserActivityPostDataItem: ActivityTableCellPostItem {
    
    var content: String {
        return "\(displayName) shared a photo."
    }
}

extension UserActivityCommentDataItem: ActivityTableCellCommentItem {
    
    var content: String {
        return "\(displayName) commented \"\(message)\" in your photo."
    }
}

extension UserActivityFollowDataItem: ActivityTableCellFollowItem {
    
    var content: String {
        return "\(displayName) started following you."
    }
}

extension UserActivityModuleInterface {
    
    func presentSinglePost(for index: Int) {
        guard let presenter = self as? UserActivityPresenter,
            let activity = activity(at: index) else {
            return
        }
        
        var postId: String?
        
        if let data = activity as? UserActivityLikeData {
            postId = data.postId
            
        } else if let data = activity as? UserActivityCommentData {
            postId = data.postId
            
        } else if let data = activity as? UserActivityPostData {
            postId = data.postId
        }
        
        let parent = presenter.view.controller
        presenter.wireframe.showSinglePost(parent: parent, postId: postId)
    }
}

extension UserActivityWireframeInterface {
    
    func showSinglePost(parent: UIViewController?, postId: String?) {
        guard postId != nil else {
            return
        }
        
        let module = SinglePostModule()
        module.build(root: root, postId: postId!)
        
        var property = WireframeEntryProperty()
        property.controller = module.view.controller
        property.parent = parent
        
        module.wireframe.style = .push
        module.wireframe.enter(with: property)
    }
}

