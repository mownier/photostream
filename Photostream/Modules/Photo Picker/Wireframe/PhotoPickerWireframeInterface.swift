//
//  PhotoPickerWireframeInterface.swift
//  Photostream
//
//  Created by Mounir Ybanez on 09/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

protocol PhotoPickerWireframeInterface: class {

    var dependencies: [PhotoPickerModuleDependency]? { set get }
    var root: RootWireframeInterface? { set get }
    
    init(root: RootWireframeInterface?, delegate: PhotoPickerModuleDelegate?, view: PhotoPickerViewInterface)
    
    func attachRoot(with controller: UIViewController, in window: UIWindow)
    
    func present(with controller: UIViewController?, from: UIViewController?, animated: Bool, completion: (() -> Void)?)
    
    func dismiss(with controller: UIViewController?, animated: Bool, completion: (() -> Void)?)
    
    func dependency<T>() -> T?
}

protocol PhotoPickerModuleDependency: class { }
