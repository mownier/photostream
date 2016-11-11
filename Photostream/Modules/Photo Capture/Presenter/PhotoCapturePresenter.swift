//
//  PhotoCapturePresenter.swift
//  Photostream
//
//  Created by Mounir Ybanez on 10/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit
import GPUImage

class PhotoCapturePresenter: PhotoCapturePresenterInterface {

    weak var moduleDelegate: PhotoCaptureModuleDelegate?
    weak var view: PhotoCaptureViewInterface!
    var wireframe: PhotoCaptureWireframeInterface!
    var camera: GPUImageStillCamera?
    var filter: GPUImageFilter?
}

extension PhotoCapturePresenter: PhotoCaptureModuleInterface {
    
    var isCameraAvailable: Bool {
        return UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    func capture() {
        guard isCameraAvailable else {
            return
        }
        
        camera?.capturePhotoAsImageProcessedUp(toFilter: filter, withCompletionHandler: { (image, error) in
            self.moduleDelegate?.photoCaptureDidFinish(with: image)
        })
    }
    
    func cancel() {
        moduleDelegate?.photoCaptureDidCanel()
    }
    
    func setupCamera(with preview: GPUImageView, cameraPosition: AVCaptureDevicePosition = .back, preset: String = AVCaptureSessionPreset640x480, outputOrientation: UIInterfaceOrientation = .portrait) {
        guard isCameraAvailable else {
            return
        }
        
        camera = GPUImageStillCamera(sessionPreset: preset, cameraPosition: cameraPosition)
        camera?.outputImageOrientation = outputOrientation
        
        filter = GPUImageBrightnessFilter()
        filter?.addTarget(preview)
        camera?.addTarget(filter)
    }
    
    func startCamera() {
        guard isCameraAvailable  else {
            return
        }
        
        camera?.startCapture()
    }
    
    func stopCamera() {
        guard isCameraAvailable else {
            return
        }
        
        camera?.stopCapture()
    }
}
