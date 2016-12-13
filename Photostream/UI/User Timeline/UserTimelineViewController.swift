//
//  UserTimelineViewController.swift
//  Photostream
//
//  Created by Mounir Ybanez on 12/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class UserTimelineViewController: UIViewController {

    var userId: String!
    
    var userPostPresenter: UserPostPresenter!
    var userProfilePresenter: UserProfilePresenter!
    
    var userTimelineView: UserTimelineView!
    
    override func loadView() {
        userTimelineView = UserTimelineView(frame: UIScreen.main.bounds)
        userTimelineView.control.delegate = self
        
        view = userTimelineView
        
        setupUserPostModule()
        setupUserProfileModule()
        
        setupNavigationItem()
        
        userTimelineView.setNeedsLayout()
        userTimelineView.layoutIfNeeded()
    }
       
    func setupUserPostModule() {
        let module = UserPostModule(sceneType: .grid)
        module.build(root: nil, userId: userId)
        module.wireframe.style = .attach
        userPostPresenter = module.presenter
        
        module.view.assignScrollEventListener(listener: self)
        
        var property = WireframeEntryProperty()
        property.parent = self
        property.controller = module.view.controller
        module.presenter.wireframe.enter(with: property)
    }
    
    func setupUserProfileModule() {
        let module = UserProfileModule()
        module.build(root: nil, userId: userId)
        module.wireframe.style = .attach
        userProfilePresenter = module.presenter
        
        var property = WireframeEntryProperty()
        property.parent = self
        property.controller = module.view.controller
        module.presenter.wireframe.enter(with: property)
    }
    
    func setupNavigationItem() {
        navigationItem.title = "Timeline"
        
        let barItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(self.didTapSettings))
        navigationItem.rightBarButtonItem = barItem
    }
}

extension UserTimelineViewController {
    
    func didTapSettings() {
        
    }
}

extension UserTimelineViewController: UserTimelineControlDelegate {
    
    func didSelectList() {
        userPostPresenter.view.killScroll()
        userPostPresenter.view.assignSceneType(type: .list)
    }
    
    func didSelectGrid() {
        userPostPresenter.view.killScroll()
        userPostPresenter.view.assignSceneType(type: .grid)
    }
    
    func didSelectLiked() {
        
    }
}

extension UserTimelineViewController: ScrollEventListener {
    
    func didScrollUp(with delta: CGFloat, offsetY: CGFloat) {
        guard offsetY > 0 else {
            return
        }
        
        var frame = userTimelineView.userProfileView!.frame
        let new = frame.origin.y + delta
        frame.origin.y = min(new, 0)
        
        userTimelineView.userProfileView!.frame = frame
        userTimelineView.setNeedsLayout()
        userTimelineView.layoutIfNeeded()
    }
    
    func didScrollDown(with delta: CGFloat, offsetY: CGFloat) {
        var frame = userTimelineView.userProfileView!.frame
        let new = frame.origin.y + delta
        frame.origin.y = max(new, -(frame.height + 4 + 1))
        
        userTimelineView.userProfileView!.frame = frame
        userTimelineView.setNeedsLayout()
        userTimelineView.layoutIfNeeded()
    }
}
