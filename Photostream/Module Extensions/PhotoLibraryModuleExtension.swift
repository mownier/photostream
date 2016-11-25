//
//  PhotoLibraryModuleExtension.swift
//  Photostream
//
//  Created by Mounir Ybanez on 11/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

extension PhotoLibraryWireframe {
    
    class func createViewController() -> PhotoLibraryViewController {
        let sb = UIStoryboard(name: "PhotoLibraryModuleStoryboard", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "PhotoLibraryViewController")
        return vc as! PhotoLibraryViewController
    }
    
    class func createNavigationController() -> UINavigationController {
        let sb = UIStoryboard(name: "PhotoLibraryModuleStoryboard", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "PhotoLibraryNavigationController")
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

extension PhotoLibraryPresenter {
    
    var router: PhotoLibraryWireframe? {
        return wireframe as? PhotoLibraryWireframe
    }
    
    func presentPhotoShare() {
        router?.showPhotoShare(from: view.controller, with: cropper.image)
    }
}

extension PhotoLibraryPresenter: PhotoPickerModuleDependency { }

