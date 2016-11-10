//
//  PhotoCapturePresenter.swift
//  Photostream
//
//  Created by Mounir Ybanez on 10/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class PhotoCapturePresenter: PhotoCapturePresenterInterface {

    weak var moduleDelegate: PhotoCaptureModuleDelegate?
    weak var view: PhotoCaptureViewInterface!
    var wireframe: PhotoCaptureWireframeInterface!
}

extension PhotoCapturePresenter: PhotoCaptureModuleInterface {
    
    func capture() {
        view.capturedImage { (image) in
            self.moduleDelegate?.photoCaptureDidFinish(with: image)
        }
    }
    
    func cancel() {
        moduleDelegate?.photoCaptureDidCanel()
    }
}
