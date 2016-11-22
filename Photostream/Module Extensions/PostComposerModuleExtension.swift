//
//  PostComposerModuleExtension.swift
//  Photostream
//
//  Created by Mounir Ybanez on 09/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

extension PostComposerPresenter {
    
    func presentPhotoShare(with image: UIImage) {
        wireframe.showPhotoShare(from: view.controller?.navigationController, with: image, delegate: self)
    }
}

extension PostComposerPresenter: PhotoCaptureModuleDelegate {
    
    func photoCaptureDidFinish(with image: UIImage?) {
        guard image != nil else {
            return
        }
        
        presentPhotoShare(with: image!)
    }
    
    func photoCaptureDidCanel() {
        print("PostComposerPresenter: did cancel capture")
    }
}

extension PostComposerPresenter: PhotoShareModuleDelegate {
    
    func photoShareDidFinish(with image: UIImage, content: String) {
        print("PostComposerPresenter: did finish share")
    }
    
    func photoShareDidCancel() {
        print("PostComposerPresenter: did cancel share")
    }
}

extension PostComposerWireframeInterface {
    
    func showPhotoShare(from navigationController: UINavigationController?, with image: UIImage, delegate: PhotoShareModuleDelegate) {
        let vc = PhotoShareWireframe.createViewController()
        vc.image = image
        let wireframe = PhotoShareWireframe(root: root, delegate: delegate, view: vc)
        wireframe.push(with: vc, from: navigationController)
    }
}

extension PostComposerWireframe {
    
    class func createViewController() -> PostComposerViewController {
        let sb = UIStoryboard(name: "PostComposerModuleStoryboard", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "PostComposerViewController")
        return vc as! PostComposerViewController
    }
    
    class func createNavigationController() -> UINavigationController {
        let sb = UIStoryboard(name: "PostComposerModuleStoryboard", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "PostComposerNavigationController")
        return vc as! UINavigationController
    }
}
