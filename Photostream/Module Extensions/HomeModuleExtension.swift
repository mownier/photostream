//
//  HomeModuleExtension.swift
//  Photostream
//
//  Created by Mounir Ybanez on 29/10/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

extension HomePresenter {
    
    var router: HomeWireframe? {
        return wireframe as? HomeWireframe
    }
    
    func presentPostComposer() {
        router?.showPostComposer(from: view.controller, delegate: self)
    }
}

extension HomePresenter: PostComposerModuleDelegate {
    
    func postComposerDidFinishWriting(view: UIView) {
        print("Post composer did finish writing...")
    }
    
    func postComposerDidCancelWriting() {
        print("Post composer did cancel writing...")
    }
}

extension HomeWireframe {
    
    static var viewController: HomeViewController {
        let sb = UIStoryboard(name: "HomeModuleStoryboard", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "HomeViewController")
        return vc as! HomeViewController
    }
    
    func loadModuleDependency(with controller: UITabBarController) {
        let feedVC = (controller.viewControllers?[0] as? UINavigationController)?.topViewController as! NewsFeedViewController
        _ = NewsFeedWireframe(root: root, view: feedVC)
        
//        let profileVC = (controller.viewControllers?[2] as? UINavigationController)?.topViewController as! UserProfileViewController
//        let profileWireframe = UserProfileWireframe(userId: nil)
//        profileWireframe.rootWireframe = root
//        profileWireframe.userProfileViewController = profileVC
//        profileWireframe.userProfilePresenter.view = profileVC
//        profileWireframe.userProfileViewController.presenter = profileWireframe.userProfilePresenter
    }
    
    func showPostComposer(from controller: UIViewController?, delegate: PostComposerModuleDelegate?) {
        guard controller != nil else {
            return
        }
        
//        let vc = PostComposerWireframe.createViewController()
//        let wireframe = PostComposerWireframe(root: root, delegate: delegate, view: vc)
//        let nav = PostComposerWireframe.createNavigationController()
//        nav.viewControllers.removeAll()
//        nav.viewControllers.append(vc)
//        wireframe.present(with: nav, from: controller!)
        
        let vc = PhotoCaptureWireframe.createViewController()
        let wireframe = PhotoCaptureWireframe(root: root, delegate: self, view: vc)
        wireframe.present(with: vc, from: controller)
    }
}

extension HomeWireframe: PhotoCaptureModuleDelegate {
    
    func photoCaptureDidFinish(with image: UIImage?) {
        if image == nil {
            print("Captured image is nil...")
        } else {
            print("Did capture image...")
        }
    }
    
    func photoCaptureDidCanel() {
        
    }
}
