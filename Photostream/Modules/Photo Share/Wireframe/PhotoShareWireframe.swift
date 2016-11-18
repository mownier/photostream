//
//  PhotoShareWireframe.swift
//  Photostream
//
//  Created by Mounir Ybanez on 18/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class PhotoShareWireframe: PhotoShareWireframeInterface {

    var root: RootWireframeInterface?
    
    required init(root: RootWireframeInterface?, view: PhotoShareViewInterface) {
        self.root = root
    }
    
    func attachRoot(with controller: UIViewController, in window: UIWindow) {
        root?.showRoot(with: controller, in: window)
    }
    
    func push(with controller: UIViewController?, from navigationController: UINavigationController?, animated: Bool) {
        guard controller != nil, navigationController != nil else {
            return
        }
        
        navigationController!.pushViewController(controller!, animated: animated)
    }
}
