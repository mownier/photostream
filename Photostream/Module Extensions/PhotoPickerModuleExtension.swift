//
//  PhotoPickerModuleExtension.swift
//  Photostream
//
//  Created by Mounir Ybanez on 09/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

extension PhotoPickerModuleInterface {
    
    func didPickPhotoFromLibrary() {
        guard let presenter = self as? PhotoPickerPresenter else {
            return
        }
        
        let photoLibraryPresenter: PhotoLibraryPresenter? = presenter.wireframe.dependency()
        photoLibraryPresenter?.done()
    }
}

extension PhotoPickerPresenter: PhotoLibraryModuleDelegate {
    
    func photoLibraryDidPick(with image: UIImage?) {
        moduleDelegate?.photoPickerDidFinish(with: image)
    }
    
    func photoLibraryDidCancel() {
        print("Photo Picker: did cancel")
    }
}

extension PhotoPickerPresenter: PhotoCaptureModuleDelegate {
    
    func photoCaptureDidFinish(with image: UIImage?) {
        moduleDelegate?.photoPickerDidFinish(with: image)
    }
    
    func photoCaptureDidCanel() {
        print("Photo Picker: did cancel capture")
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
