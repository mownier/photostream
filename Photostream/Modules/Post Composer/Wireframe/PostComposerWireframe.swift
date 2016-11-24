//
//  PostComposerWireframe.swift
//  Photostream
//
//  Created by Mounir Ybanez on 09/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class PostComposerWireframe: PostComposerWireframeInterface {

    lazy var dependencies: [PostComposerModuleDependency]? = [PostComposerModuleDependency]()
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
    
    func dependency<T>() -> T? {
        guard dependencies != nil, dependencies!.count > 0 else {
            return nil
        }
        
        let result = dependencies!.filter { (dependency) -> Bool in
            return type(of: dependency) == T.self
        }
        
        guard result.count > 0 else {
            return nil
        }
        
        return result[0] as? T
    }
}
