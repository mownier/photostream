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
        userTimelineView.header.control.delegate = self
        
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
        module.view.assignRefreshEventTarget(target: self, action: #selector(self.didRefreshPosts))
        
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
        
        let barItem = UIBarButtonItem(image: #imageLiteral(resourceName: "settings_icon"), style: .plain, target: self, action: #selector(self.didTapSettings))
        navigationItem.rightBarButtonItem = barItem
    }
}

extension UserTimelineViewController {
    
    func didTapSettings() {
        var section = SettingSection()
        section.items.append("Sign out")
        
        let module = SettingsModule()
        module.build(root: nil, sections: [section])
        
        var property = WireframeEntryProperty()
        property.controller = module.view.controller
        property.parent = self
        
        module.wireframe.style = .push
        module.wireframe.enter(with: property)
    }
    
    func didRefreshPosts() {
        userProfilePresenter.fetchUserProfile()
    }
}

extension UserTimelineViewController: UserTimelineControlDelegate {
    
    func didSelectList() {
        userPostPresenter.view.killScroll()
        userPostPresenter.view.assignSceneType(type: .list)
        resetUserTimelineView()
    }
    
    func didSelectGrid() {
        userPostPresenter.view.killScroll()
        userPostPresenter.view.assignSceneType(type: .grid)
        resetUserTimelineView()
    }
    
    func didSelectLiked() {
        
    }
    
    private func resetUserTimelineView() {
        userTimelineView.header.frame.origin.y = 0
        
        var offset = CGPoint.zero
        offset.y = -userTimelineView.header.frame.height
        userPostPresenter.view.assignContent(offset: offset)
    }
}

extension UserTimelineViewController: ScrollEventListener {
    
    func didScrollUp(with delta: CGFloat, offsetY: CGFloat) {
        guard offsetY < -headerStopperOffset else {
            return
        }
        
        var newY = headerOriginY + abs(delta)
        newY = min(newY, 0)
        
        userTimelineView.header.frame.origin.y = newY
        userTimelineView.setNeedsLayout()
        userTimelineView.layoutIfNeeded()
    }
    
    func didScrollDown(with delta: CGFloat, offsetY: CGFloat) {
        var newY = headerOriginY - abs(delta)
        newY = max(newY, -headerStopper)
        
        userTimelineView.header.frame.origin.y = newY
        userTimelineView.setNeedsLayout()
        userTimelineView.layoutIfNeeded()
    }
    
    private var headerStopper: CGFloat {
        var stopper = userTimelineView.header.frame.height
        stopper -= headerStopperOffset
        return stopper
    }
    
    private var headerStopperOffset: CGFloat {
        return userTimelineView.header.control.frame.height - 1
    }
    
    private var headerOriginY: CGFloat {
        return userTimelineView.header.frame.origin.y
    }
}
