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
        router?.showPostComposer(from: view.controller, delegate: self, photoCaptureDelegate: self, photoPickerDelegate: self)
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
    
    func showPostComposer(from controller: UIViewController?, delegate: PostComposerModuleDelegate?, photoCaptureDelegate: PhotoCaptureModuleDelegate?, photoPickerDelegate: PhotoPickerModuleDelegate?) {
        guard controller != nil else {
            return
        }
        
        // Assemble Photo Capture module
        let photoCaptureViewController = PhotoCaptureWireframe.createViewController()
        let _ = PhotoCaptureWireframe(root: root, delegate: photoCaptureDelegate, view: photoCaptureViewController)
        
        // Assemble Photo Picker module
        let photoPickerViewController = PhotoPickerWireframe.createViewController()
        let _ = PhotoPickerWireframe(root: root, delegate: photoPickerDelegate, view: photoPickerViewController)
        
        // Assemble Post Composer module
        let postComposerViewController = PostComposerWireframe.createViewController()
        let postComposerWireframe = PostComposerWireframe(root: root, delegate: delegate, view: postComposerViewController)
        let postComposerNavController = PostComposerWireframe.createNavigationController()
        postComposerNavController.viewControllers.removeAll()
        postComposerNavController.viewControllers.append(postComposerViewController)
        
        // Dependency controllers
        let controllers = [photoPickerViewController, photoCaptureViewController]
        postComposerViewController.setupDependency(with: controllers)
        
        // Present Post Composer module
        postComposerWireframe.present(with: postComposerNavController, from: controller!)
    }
}

extension HomePresenter: PhotoCaptureModuleDelegate {
    
    func photoCaptureDidCanel() {
        print("Photo capture did cancel")
    }
    
    func photoCaptureDidFinish(with image: UIImage?) {
        print("Photo capture did capture")
    }
}

extension HomePresenter: PhotoPickerModuleDelegate {
    
    func photoPickerDidCancel() {
        print("Photo picker did cancel")
    }
    
    func photoPickerDidPick(with image: UIImage?) {
        print("Photo picker did pick image")
    }
}

extension HomePresenter: PhotoShareModuleDelegate {
    
    func photoShareDidCancel() {
        print("Photo Share did cancel")
    }
    
    func photoShareDidFinish(with image: UIImage, content: String) {
        print("Photo Shared did finish.")
    }
}
