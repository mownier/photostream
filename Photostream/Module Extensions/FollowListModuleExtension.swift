//
//  FollowListModuleExtension.swift
//  Photostream
//
//  Created by Mounir Ybanez on 17/01/2017.
//  Copyright © 2017 Mounir Ybanez. All rights reserved.
//

import UIKit

extension FollowListModule {
    
    convenience init() {
        self.init(view: FollowListViewController())
    }
}

extension FollowListDisplayDataItem: UserTableCellItem { }

extension FollowListModuleInterface {
    
    func presentUserTimeline(for index: Int) {
        guard let presenter = self as? FollowListPresenter,
            let item = listItem(at: index) else {
            return
        }
        
        presenter.wireframe.showUserTimeline(
            from: presenter.view.controller,
            userId: item.userId
        )
    }
}

extension FollowListWireframeInterface {
    
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
