//
//  PostComposerWireframe.swift
//  Photostream
//
//  Created by Mounir Ybanez on 09/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class PostComposerWireframe: PostComposerWireframeInterface {

    var root: RootWireframeInterface?
    
    required init(root: RootWireframeInterface?, delegate: PostComposerModuleDelegate?, view: PostComposerViewInterface) {
        self.root = root
    
        let presenter = PostComposerPresenter()
        presenter.moduleDelegate = delegate
        presenter.view = view
        presenter.wireframe = self
        
        view.presenter = presenter
    }
    
    func attachRoot(with controller: UIViewController, in window: UIWindow) {
        root?.showRoot(with: controller, in: window)
    }
    
    func present(with controller: UIViewController?, from: UIViewController?, animated: Bool = true, completion: (() -> Void)? = nil) {
        guard controller != nil else {
            return
        }
        
        from?.present(controller!, animated: animated, completion: completion)
    }
    
    func dismiss(with controller: UIViewController?, animated: Bool = true, completion: (() -> Void)? = nil) {
        guard controller != nil else {
            return
        }
        
        controller!.dismiss(animated: animated, completion: completion)
    }
}
