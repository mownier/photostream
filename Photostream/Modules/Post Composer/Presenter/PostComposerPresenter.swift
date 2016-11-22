//
//  PostComposerPresenter.swift
//  Photostream
//
//  Created by Mounir Ybanez on 09/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class PostComposerPresenter: PostComposerPresenterInterface {
    
    weak var moduleDelegate: PostComposerModuleDelegate?
    weak var view: PostComposerViewInterface!
    var wireframe: PostComposerWireframeInterface!
    var source: PhotoSource = .unknown {
        didSet {
            guard source != oldValue else {
                return
            }
            
            switch source {
            case .library:
                view.showLibrary()
            case .camera:
                view.showCamera()
            case .unknown:
                break
            }
        }
    }
}

extension PostComposerPresenter: PostComposerModuleInterface {
    
    func cancelWriting() {
        moduleDelegate?.postComposerDidCancelWriting()
        wireframe.dismiss(with: view.controller, animated: true, completion: nil)
    }
    
    func doneWriting() {
        moduleDelegate?.postComposerDidFinishWriting(view: UIView())
        wireframe.dismiss(with: view.controller, animated: true, completion: nil)
    }
    
    func willShowCamera() {
        source = .camera
    }
    
    func willShowLibrary() {
        source = .library
    }
}
