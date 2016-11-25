//
//  PostComposerNavigationController.swift
//  Photostream
//
//  Created by Mounir Ybanez on 25/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

protocol PostComposerDelegate: class {
    
    func postComposerDidFinish(with image: UIImage, content: String)
    func postComposerDidCancel()
}

class PostComposerNavigationController: UINavigationController {

    weak var moduleDelegate: PostComposerDelegate?
    
    var photoPicker: PhotoPickerViewController!
    var photoShare: PhotoShareViewController!
    
    required convenience init(photoPicker: PhotoPickerViewController, photoShare: PhotoShareViewController) {
        self.init(rootViewController: photoPicker)
        self.photoPicker = photoPicker
        self.photoShare = photoShare
    }
    
    override func loadView() {
        super.loadView()
        
        navigationBar.isTranslucent = false
        navigationBar.tintColor = UIColor(red: 10/255, green: 10/255, blue: 10/255, alpha: 1)
    }
    
    func dismiss() {
        dismiss(animated: true, completion: nil)
    }
}

extension PostComposerNavigationController: PhotoPickerModuleDelegate {

    func photoPickerDidCancel() {
        moduleDelegate?.postComposerDidCancel()
        dismiss()
    }
    
    func photoPickerDidFinish(with image: UIImage?) {
        guard image != nil else {
            return
        }
        photoShare.image = image
        pushViewController(photoShare, animated: true)
    }
}

extension PostComposerNavigationController: PhotoShareModuleDelegate {
    
    func photoShareDidCancel() {
        photoShare.image = nil
        let _ = popViewController(animated: true)
    }
    
    func photoShareDidFinish(with image: UIImage, content: String) {
        moduleDelegate?.postComposerDidFinish(with: image, content: content)
        dismiss()
    }
}
