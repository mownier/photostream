//
//  PhotoCaptureWireframeInterface.swift
//  Photostream
//
//  Created by Mounir Ybanez on 10/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

protocol PhotoCaptureWireframeInterface: class {

    var root: RootWireframeInterface? { set get }
    
    init(root: RootWireframeInterface?, delegate: PhotoCaptureModuleDelegate?, view: PhotoCaptureViewInterface)
    
    func attachRoot(with controller: UIViewController, in window: UIWindow)
    
    func present(with controller: UIViewController?, from parent: UIViewController?, animated: Bool, completion: (() -> Void)?)
}
