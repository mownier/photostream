//
//  PhotoPickerWireframeInterface.swift
//  Photostream
//
//  Created by Mounir Ybanez on 11/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

protocol PhotoPickerWireframeInterface: class {

    var root: RootWireframeInterface? { set get }
    
    init(root: RootWireframeInterface?, delegate: PhotoPickerModuleDelegate?, view: PhotoPickerViewInterface)
    
    func attachRoot(with controller: UIViewController, in window: UIWindow)
    
    func present(with controller: UIViewController?, from parent: UIViewController?, animated: Bool, completion: (() -> Void)?)
    func dismiss(with controller: UIViewController?, animated: Bool, completion: (() -> Void)?)
}

extension PhotoPickerWireframeInterface {
    
    func present(with controller: UIViewController?, from parent: UIViewController?, animated: Bool = true, completion: (() -> Void)? = nil) {
        present(with: controller, from: parent, animated: animated, completion: completion)
    }
    
    func dismiss(with controller: UIViewController?) {
        dismiss(with: controller, animated: true, completion: nil)
    }
}
