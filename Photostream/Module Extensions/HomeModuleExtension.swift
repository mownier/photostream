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
    }
    
    func showPostComposer(from controller: UIViewController?, delegate: PostComposerModuleDelegate?) {
        guard controller != nil else {
            return
        }
        
        // Assemble Post Composer module
        let postComposerViewController = PostComposerWireframe.createViewController()
        let postComposerWireframe = PostComposerWireframe(root: root, delegate: delegate, view: postComposerViewController)
        { presenter in
            guard let postComposerPresenter = presenter as? PostComposerPresenter else {
                return
            }
            
            // Assemble Photo Capture module
            let photoCaptureViewController = PhotoCaptureWireframe.createViewController()
            let _ = PhotoCaptureWireframe(root: self.root, delegate: postComposerPresenter, view: photoCaptureViewController)
            
            // Assemble Photo Picker module
            let photoPickerViewController = PhotoPickerWireframe.createViewController()
            let _ = PhotoPickerWireframe(root: self.root, delegate: nil, view: photoPickerViewController)
            
            // Dependency controllers
            let controllers = [photoPickerViewController, photoCaptureViewController]
            postComposerViewController.setupDependency(with: controllers)
        }
        
        // Instantiate navigation controller
        let postComposerNavController = PostComposerWireframe.createNavigationController()
        postComposerNavController.viewControllers.removeAll()
        postComposerNavController.viewControllers.append(postComposerViewController)
        
        // Present Post Composer module
        postComposerWireframe.present(with: postComposerNavController, from: controller!)
    }
}
