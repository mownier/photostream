//
//  PhotoPickerModuleExtension.swift
//  Photostream
//
//  Created by Mounir Ybanez on 09/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

extension PhotoPickerPresenter {
    
    func didPickPhoto() {
        guard let presenter: PhotoLibraryPresenter = wireframe.dependency() else {
            return
        }
        
        presenter.done()
    }
    
    func presentPhotoShare(with image: UIImage) {
        wireframe.showPhotoShare(from: view.controller?.navigationController, with: image, delegate: self)
    }
}

extension PhotoPickerPresenter: PhotoLibraryModuleDelegate {
    
    func photoLibraryDidPick(with image: UIImage?) {
        guard image != nil else {
            return
        }
        
        presentPhotoShare(with: image!)
    }
    
    func photoLibraryDidCancel() {
        print("Post Composer: did cancel pick")
    }
}

extension PhotoPickerPresenter: PhotoCaptureModuleDelegate {
    
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

extension PhotoPickerPresenter: PhotoShareModuleDelegate {
    
    func photoShareDidFinish(with image: UIImage, content: String) {
        moduleDelegate?.photoPickerDidFinishWriting(with: image, content: content)
    }
    
    func photoShareDidCancel() {
        print("Post Composer: did cancel share")
    }
}

extension PhotoPickerWireframeInterface {
    
    func showPhotoShare(from navigationController: UINavigationController?, with image: UIImage, delegate: PhotoShareModuleDelegate) {
        let vc = PhotoShareWireframe.createViewController()
        vc.image = image
        let wireframe = PhotoShareWireframe(root: root, delegate: delegate, view: vc)
        wireframe.push(with: vc, from: navigationController)
    }
}

extension PhotoPickerWireframe {
    
    class func createViewController() -> PhotoPickerViewController {
        let sb = UIStoryboard(name: "PhotoPickerModuleStoryboard", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "PhotoPickerViewController")
        return vc as! PhotoPickerViewController
    }
    
    class func createNavigationController() -> UINavigationController {
        let sb = UIStoryboard(name: "PhotoPickerModuleStoryboard", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "PhotoPickerNavigationController")
        return vc as! UINavigationController
    }
}
