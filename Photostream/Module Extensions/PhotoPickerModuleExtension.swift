//
//  PhotoPickerModuleExtension.swift
//  Photostream
//
//  Created by Mounir Ybanez on 11/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

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
    
    func showPhotoShare(from controller: UIViewController?, with image: UIImage?) {
        guard controller != nil, image != nil else {
            return
        }
        
        let vc = PhotoShareWireframe.createViewController()
        vc.image = image!
        let wireframe = PhotoShareWireframe(root: root, delegate: nil, view: vc)
        wireframe.push(with: vc, from: controller!.navigationController)
    }
}

extension PhotoPickerPresenter {
    
    var router: PhotoPickerWireframe? {
        return wireframe as? PhotoPickerWireframe
    }
    
    func presentPhotoShare() {
        router?.showPhotoShare(from: view.controller, with: cropper.image)
    }
}

extension PhotoPickerPresenter: PostComposerModuleDependency { }

