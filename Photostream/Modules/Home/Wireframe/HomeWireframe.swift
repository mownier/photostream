//
//  HomeWireframe.swift
//  Photostream
//
//  Created by Mounir Ybanez on 15/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

struct HomeWireframe: HomeWireframeInterface {
    
    var root: RootWireframeInterface?
    
    init(root: RootWireframeInterface?, view: HomeViewInterface) {
        self.root = root
        
        let presenter = HomePresenter()
        presenter.view = view
        presenter.wireframe = self
        
        view.presenter = presenter
    }
    
    func attachRoot(with controller: UIViewController, in window: UIWindow) {
        root?.showRoot(with: controller, in: window)
    }
}
