//
//  PhotoPickerWireframe.swift
//  Photostream
//
//  Created by Mounir Ybanez on 11/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class PhotoPickerWireframe: PhotoPickerWireframeInterface {

    var root: RootWireframeInterface?
    
    required init(root: RootWireframeInterface?, delegate: PhotoPickerModuleDelegate?, view: PhotoPickerViewInterface) {
        self.root = root
    }
    
    func attachRoot(with controller: UIViewController, in window: UIWindow) {
        root?.showRoot(with: controller, in: window)
    }
}
