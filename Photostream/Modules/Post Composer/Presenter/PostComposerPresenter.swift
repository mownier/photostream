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
}
