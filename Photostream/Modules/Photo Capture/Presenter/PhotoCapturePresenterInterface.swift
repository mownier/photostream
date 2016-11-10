//
//  PhotoCapturePresenterInterface.swift
//  Photostream
//
//  Created by Mounir Ybanez on 10/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

protocol PhotoCapturePresenterInterface: class {

    var view: PhotoCaptureViewInterface! { set get }
    var wireframe: PhotoCaptureWireframeInterface! { set get }
    var moduleDelegate: PhotoCaptureModuleDelegate? { set get }
}
