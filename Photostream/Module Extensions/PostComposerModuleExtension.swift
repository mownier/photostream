//
//  PostComposerModuleExtension.swift
//  Photostream
//
//  Created by Mounir Ybanez on 09/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

extension PostComposerPresenter {
    
    func didPickPhoto() {
        guard let presenter: PhotoPickerPresenter = wireframe.dependency() else {
            return
        }
        
        presenter.done()
    }
    
    func presentPhotoShare(with image: UIImage) {
        wireframe.showPhotoShare(from: view.controller?.navigationController, with: image, delegate: self)
    }
}

extension PostComposerPresenter: PhotoPickerModuleDelegate {
    
    func photoPickerDidPick(with image: UIImage?) {
        guard image != nil else {
            return
        }
        
        presentPhotoShare(with: image!)
    }
    
    func photoPickerDidCancel() {
        print("Post Composer: did cancel pick")
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
        print("Post Composer: did cancel capture")
    }
}

extension PostComposerPresenter: PhotoShareModuleDelegate {
    
    func photoShareDidFinish(with image: UIImage, content: String) {
        moduleDelegate?.postComposerDidFinishWriting(with: image, content: content)
    }
    
    func photoShareDidCancel() {
        print("Post Composer: did cancel share")
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
