//
//  PostLikeModuleExtension.swift
//  Photostream
//
//  Created by Mounir Ybanez on 20/01/2017.
//  Copyright © 2017 Mounir Ybanez. All rights reserved.
//

import UIKit

extension PostLikeModule {

    convenience init() {
        self.init(view: PostLikeViewController())
    }
}

extension PostLikeDisplayDataItem: UserTableCellItem { }

extension PostLikeModuleInterface {
    
    func presentUserTimeline(for index: Int) {
        guard let presenter = self as? PostLikePresenter,
            let like = like(at: index) else {
                return
        }
        
        presenter.wireframe.showUserTimeline(
            from: presenter.view.controller,
            userId: like.userId
        )
    }
}

extension PostLikeWireframeInterface {
    
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
}
