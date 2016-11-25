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

extension HomePresenter: PhotoPickerModuleDelegate {
    
    func photoPickerDidFinishWriting(with image: UIImage, content: String) {
        guard let presenter: NewsFeedPresenter = wireframe.dependency() else {
            return
        }
        
        router?.showPostUpload(in: presenter.view.controller, delegate: self, image: image, content: content)
    }
    
    func photoPickerDidCancelWriting() {
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
        
        if presenter.feedCount > 0 {
            presenter.refreshFeeds()
        } else {
            presenter.initialLoad()
        }
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
        dependencies?.append(feedVC.presenter as! HomeModuleDependency)
    }
    
    func showPostComposer(from controller: UIViewController?, delegate: PhotoPickerModuleDelegate?) {
        guard controller != nil else {
            return
        }
        
        // Assemble Post Composer module
        let photoPickerViewController = PhotoPickerWireframe.createViewController()
        let photoPickerWireframe = PhotoPickerWireframe(root: root, delegate: delegate, view: photoPickerViewController)
        let photoPickerPresenter = photoPickerViewController.presenter as! PhotoPickerPresenter
        
        // Assemble Photo Capture module
        let photoCaptureViewController = PhotoCaptureWireframe.createViewController()
        let _ = PhotoCaptureWireframe(root: root, delegate: photoPickerPresenter, view: photoCaptureViewController)
        
        // Assemble Photo Picker module
        let photoLibraryViewController = PhotoLibraryWireframe.createViewController()
        let _ = PhotoLibraryWireframe(root: root, delegate: photoPickerPresenter, view: photoLibraryViewController)
        
        // Dependency controllers
        let controllers = [photoLibraryViewController, photoCaptureViewController]
        photoPickerViewController.setupDependency(with: controllers)
        
        // Instantiate navigation controller
        let photoPickerNavController = PhotoPickerWireframe.createNavigationController()
        photoPickerNavController.viewControllers.removeAll()
        photoPickerNavController.viewControllers.append(photoPickerViewController)
        
        // Add necessary dependency
        let dependency = photoLibraryViewController.presenter as! PhotoPickerModuleDependency
        photoPickerWireframe.dependencies?.append(dependency)
        
        // Present Post Composer module
        photoPickerWireframe.present(with: photoPickerNavController, from: controller!)
    }
    
    func showPostUpload(in controller: UIViewController?, delegate: PostUploadModuleDelegate?, image: UIImage, content: String) {
        guard controller != nil else {
            return
        }
        
        let vc = PostUploadViewController()
        let wireframe = PostUploadWireframe(root: root, delegate: delegate, view: vc, image: image, content: content)
        wireframe.attach(with: vc, in: controller!)
    }
}
