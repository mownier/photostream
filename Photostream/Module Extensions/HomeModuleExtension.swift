//
//  HomeModuleExtension.swift
//  Photostream
//
//  Created by Mounir Ybanez on 29/10/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

extension HomePresenterInterface {
    
    func presentPostComposer() {
        guard let presenter = self as? HomePresenter else {
            return
        }
        
        wireframe.showPostComposer(from: view.controller, delegate: presenter)
    }
}

extension HomePresenter: PostComposerDelegate {
    
    func postComposerDidFinish(with image: UIImage, content: String) {
        guard let presenter: NewsFeedPresenter = wireframe.dependency() else {
            return
        }
        
        wireframe.showPostUpload(in: presenter.view.controller, delegate: self, image: image, content: content)
    }
    
    func postComposerDidCancel() {
        print("Post composer did cancel writing...")
    }
}

extension HomePresenter: PostUploadModuleDelegate {
    
    func postUploadDidFail(with message: String) {
        print("Home Presenter: post upload did fail ==>", message)
    }
    
    func postUploadDidRetry() {
        print("Home Presenter: post upload did retry")
    }
    
    func postUploadDidSucceed(with post: UploadedPost) {
        guard let presenter: NewsFeedPresenter = wireframe.dependency() else {
            return
        }
        
        presenter.feed.items.insert(post.covertToNewsFeedPost(), at: 0)
        presenter.view.reloadView()
    }
}

extension HomeWireframe {
    
    static var viewController: HomeViewController {
        let sb = UIStoryboard(name: "HomeModuleStoryboard", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "HomeViewController")
        return vc as! HomeViewController
    }
    
    func loadModuleDependency(with controller: UITabBarController) {
        // Load news feed module
        let feedVC = (controller.viewControllers?[0] as? UINavigationController)?.topViewController as! NewsFeedViewController
        let module = NewsFeedModule(view: feedVC)
        module.build(root: root as? RootWireframe)
        dependencies?.append(module.presenter)
        
        // Load user timeline supermodule
        let auth = AuthSession()
        let userTimeline = UserTimelineViewController()
        userTimeline.userId = auth.user.id
        userTimeline.root = root as? RootWireframe
        
        var nav = UINavigationController(rootViewController: userTimeline)
        nav.tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "user_line_icon"), selectedImage: #imageLiteral(resourceName: "user_black_icon"))
        nav.tabBarItem.imageInsets.top = 8
        nav.tabBarItem.imageInsets.bottom = -8
        nav.navigationBar.isTranslucent = false
        nav.navigationBar.tintColor = UIColor(red: 10/255, green: 10/255, blue: 10/255, alpha: 1)
        controller.viewControllers?.append(nav)
        
        userTimeline.preloadView()
        
        // Load post discovery module
        let postDiscovery = PostDiscoveryModule()
        postDiscovery.build(root: root as? RootWireframe)
        
        nav = UINavigationController(rootViewController: postDiscovery.view.controller!)
        nav.tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "discovery_line_icon"), selectedImage: #imageLiteral(resourceName: "discovery_black_icon"))
        nav.tabBarItem.imageInsets.top = 8
        nav.tabBarItem.imageInsets.bottom = -8
        nav.navigationBar.isTranslucent = false
        nav.navigationBar.tintColor = UIColor(red: 10/255, green: 10/255, blue: 10/255, alpha: 1)
        controller.viewControllers?.insert(nav, at: 1)
        
        postDiscovery.view.controller?.preloadView()
        
        // Load user activity module
        let userActivity = UserActivityModule()
        userActivity.build(root: root as? RootWireframe, userId: auth.user.id)
        
        nav = UINavigationController(rootViewController: userActivity.view.controller!)
        nav.tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "heart_home_icon"), selectedImage: #imageLiteral(resourceName: "heart_home_icon_black"))
        nav.tabBarItem.imageInsets.top = 8
        nav.tabBarItem.imageInsets.bottom = -8
        nav.navigationBar.isTranslucent = false
        nav.navigationBar.tintColor = UIColor(red: 10/255, green: 10/255, blue: 10/255, alpha: 1)
        controller.viewControllers?.insert(nav, at: 3)
        
        userActivity.view.controller?.preloadView()
    }
}

extension HomeWireframeInterface {
    
    func showPostUpload(in controller: UIViewController?, delegate: PostUploadModuleDelegate?, image: UIImage, content: String) {
        guard controller != nil else {
            return
        }
        
        let vc = PostUploadViewController()
        let item = PostUploadItem(image: image, content: content)
        let wireframe = PostUploadWireframe(root: root, delegate: delegate, view: vc, item: item)
        wireframe.attach(with: vc, in: controller!)
    }
    
    func showPostComposer(from controller: UIViewController?, delegate: PostComposerDelegate?) {
        guard controller != nil else {
            return
        }
        
        // Create necessary views
        let photoShareView = PhotoShareWireframe.createViewController()
        let photoCaptureView = PhotoCaptureWireframe.createViewController()
        let photoLibraryView = PhotoLibraryWireframe.createViewController()
        let photoPickerView = PhotoPickerWireframe.createViewController()
        let postComposer = PostComposerNavigationController(photoPicker: photoPickerView, photoShare: photoShareView)
        
        // Create necessary wireframes
        let photoPickerWireframe = PhotoPickerWireframe(root: root, delegate: postComposer, view: photoPickerView)
        let _ = PhotoShareWireframe(root: root, delegate: postComposer, view: photoShareView)
        let photoPickerPresenter = photoPickerView.presenter as! PhotoPickerPresenter
        let _ = PhotoCaptureWireframe(root: root, delegate: photoPickerPresenter, view: photoCaptureView)
        let _ = PhotoLibraryWireframe(root: root, delegate: photoPickerPresenter, view: photoLibraryView)
        
        // Configure dependencies
        let photoLibraryPresenter = photoLibraryView.presenter as! PhotoPickerModuleDependency
        photoPickerWireframe.dependencies?.append(photoLibraryPresenter)
        photoPickerView.setupDependency(with: [photoLibraryView, photoCaptureView])
        postComposer.moduleDelegate = delegate
        
        // Preset post composer
        controller!.present(postComposer, animated: true, completion: nil)
    }
}
