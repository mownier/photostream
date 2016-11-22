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
        wireframe.showPhotoShare(from: view.controller?.navigationController, with: image)
    }
}

extension PostComposerWireframeInterface {
    
    func showPhotoShare(from navigationController: UINavigationController?, with image: UIImage) {
        let vc = PhotoShareWireframe.createViewController()
        vc.image = image
        let wireframe = PhotoShareWireframe(root: root, view: vc)
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
