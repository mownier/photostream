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
}
