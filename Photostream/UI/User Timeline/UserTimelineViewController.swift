//
//  UserTimelineViewController.swift
//  Photostream
//
//  Created by Mounir Ybanez on 12/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class UserTimelineViewController: UIViewController, BaseModuleWireframe {

    var root: RootWireframe?
    var style: WireframeStyle! = .unknown
    
    var userId: String!
    
    var userPostPresenter: UserPostPresenter!
    var userProfilePresenter: UserProfilePresenter!
    
    var userTimelineView: UserTimelineView!
    
    var isMe: Bool {
        let session = AuthSession()
        return session.user.id == userId
    }
    
    convenience required init(root: RootWireframe?) {
        self.init()
        self.root = root
    }
    
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
        module.build(root: root, userId: userId)
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
        module.build(root: root, userId: userId, delegate: self)
        module.wireframe.style = .attach
        userProfilePresenter = module.presenter
        
        var property = WireframeEntryProperty()
        property.parent = self
        property.controller = module.view.controller
        module.presenter.wireframe.enter(with: property)
    }
    
    func setupNavigationItem() {
        navigationItem.title = "Timeline"
        
        if isMe {
            let barItem = UIBarButtonItem(image: #imageLiteral(resourceName: "settings_icon"), style: .plain, target: self, action: #selector(self.didTapSettings))
            navigationItem.rightBarButtonItem = barItem
        }
        
        switch style! {
        case .push:
            let barItem =  UIBarButtonItem(image: #imageLiteral(resourceName: "back_nav_icon"), style: .plain, target: self, action: #selector(self.didTapBack))
            navigationItem.leftBarButtonItem = barItem
        default:
            break
        }
    }
}

extension UserTimelineViewController {
    
    func didTapSettings() {
        let module = SettingsModule()
        module.build(root: root, sections: module.defaultSections)
        
        var property = WireframeEntryProperty()
        property.controller = module.view.controller
        property.parent = self
        
        module.wireframe.style = .push
        module.wireframe.enter(with: property)
    }
    
    func didTapBack() {
        var property = WireframeExitProperty()
        property.controller = self
        exit(with: property)
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
        let module = LikedPostModule()
        module.build(root: root, userId: userId)
        
        var property = WireframeEntryProperty()
        property.parent = self
        property.controller = module.view.controller
        
        module.wireframe.style = .push
        module.wireframe.enter(with: property)
    }
    
    private func resetUserTimelineView() {
        userTimelineView.header.frame.origin.y = 0
        
        var offset = CGPoint.zero
        offset.y = -userTimelineView.header.frame.height
        userPostPresenter.view.assignContent(offset: offset)
        
        userTimelineView.setNeedsLayout()
        userTimelineView.layoutIfNeeded()
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

extension UserTimelineViewController: UserProfileDelegate {
    
    func userProfileDidSetupInfo() {
        userTimelineView.header.setNeedsLayout()
        userTimelineView.header.layoutIfNeeded()
        userTimelineView.setNeedsLayout()
        userTimelineView.layoutIfNeeded()
    }
    
    func userProfileDidFollow() {
        
    }
    
    func userProfileDidUnfollow() {
        
    }
}
