//
//  HomeWireframe.swift
//  Photostream
//
//  Created by Mounir Ybanez on 15/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class HomeWireframe: HomeWireframeInterface {
    
    lazy var dependencies: [HomeModuleDependency]? = [HomeModuleDependency]()
    
    var root: RootWireframeInterface?
    
    required init(root: RootWireframeInterface?, view: HomeViewInterface) {
        self.root = root
        
        let presenter = HomePresenter()
        presenter.view = view
        presenter.wireframe = self
        
        view.presenter = presenter
    }
    
    func attachRoot(with controller: UIViewController, in window: UIWindow) {
        root?.showRoot(with: controller, in: window)
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
