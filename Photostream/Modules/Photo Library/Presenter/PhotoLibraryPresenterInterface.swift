//
//  PhotoLibraryPresenterInterface.swift
//  Photostream
//
//  Created by Mounir Ybanez on 11/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Photos

protocol PhotoLibraryPresenterInterface: class {

    var interactor: PhotoLibraryInteractorInput! { set get }
    var view: PhotoLibraryViewInterface! { set get }
    var wireframe: PhotoLibraryWireframeInterface! { set get }
    var moduleDelegate: PhotoLibraryModuleDelegate? { set get }
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

