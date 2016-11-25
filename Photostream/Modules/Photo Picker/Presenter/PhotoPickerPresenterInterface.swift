//
//  PhotoPickerPresenterInterface.swift
//  Photostream
//
//  Created by Mounir Ybanez on 09/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

protocol PhotoPickerPresenterInterface: class {

    var view: PhotoPickerViewInterface! { set get }
    var wireframe: PhotoPickerWireframeInterface! { set get }
    var moduleDelegate: PhotoPickerModuleDelegate? { set get }
    var source: PhotoSource { set get }
}

enum PhotoSource {
    case library
    case camera
    case unknown
}
