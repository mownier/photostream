//
//  HomeWireframeInterface.swift
//  Photostream
//
//  Created by Mounir Ybanez on 29/10/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

protocol HomeWireframeInterface {

    var root: RootWireframeInterface? { set get }
    var dependencies: [HomeModuleDependency]? { set get }
    
    init(root: RootWireframeInterface?, view: HomeViewInterface)
    
    func attachRoot(with controller: UIViewController, in window: UIWindow)
    
    func dependency<T>() -> T?
}

protocol HomeModuleDependency { }
