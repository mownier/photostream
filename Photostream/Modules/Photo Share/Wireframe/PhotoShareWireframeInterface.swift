//
//  PhotoShareWireframeInterface.swift
//  Photostream
//
//  Created by Mounir Ybanez on 18/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

protocol PhotoShareWireframeInterface: class {

    var root: RootWireframeInterface? { set get }
    
    init(root: RootWireframeInterface?, delegate: PhotoShareModuleDelegate?, view: PhotoShareViewInterface)
    
    func attachRoot(with controller: UIViewController, in window: UIWindow)
    
    func push(with controller: UIViewController?, from navigationController: UINavigationController?, animated: Bool)
    func pop(from navigationController: UINavigationController?, animated: Bool)
    
    func dismiss(with controller: UIViewController?, animated: Bool, completion: (() -> Void)?)
}

extension PhotoShareWireframeInterface {
    
    func push(with controller: UIViewController?, from navigationController: UINavigationController?) {
        push(with: controller, from: navigationController, animated: true)
    }
    
    func pop(from navigationController: UINavigationController?) {
        pop(from: navigationController, animated: true)
    }
    
    func dismiss(with controller: UIViewController) {
        dismiss(with: controller, animated: true, completion: nil)
    }
}
