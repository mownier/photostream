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
}
