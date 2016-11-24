//
//  PhotoPickerPresenterInterface.swift
//  Photostream
//
//  Created by Mounir Ybanez on 11/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit
import Photos

protocol PhotoPickerPresenterInterface: class {

    var interactor: PhotoPickerInteractorInput! { set get }
    var view: PhotoPickerViewInterface! { set get }
    var wireframe: PhotoPickerWireframeInterface! { set get }
    var moduleDelegate: PhotoPickerModuleDelegate? { set get }
    var photos: [PHAsset] { set get }
    var contentMode: PhotoContentMode { set get }
    var cropper: PhotoCropper! { set get }
}

enum PhotoContentMode {
    case fill(Bool)
    case fit(Bool)
}

protocol PhotoCropper: class {
    
    var image: UIImage? { get }
}

