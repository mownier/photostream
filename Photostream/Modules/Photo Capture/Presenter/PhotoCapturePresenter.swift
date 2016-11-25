//
//  PhotoCapturePresenter.swift
//  Photostream
//
//  Created by Mounir Ybanez on 10/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

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
        
        filter = GPUImageCropFilter(cropRegion: squareCropRegion(for: preset))
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

extension PhotoCapturePresenter {
    
    func squareCropRegion(for preset: String) -> CGRect {
        switch preset {
        case AVCaptureSessionPreset640x480:
            return squareCropRegion(for: CGSize(width: 640, height: 480))
        case AVCaptureSessionPreset352x288:
            return squareCropRegion(for: CGSize(width: 352, height: 288))
        case AVCaptureSessionPreset1280x720:
            return squareCropRegion(for: CGSize(width: 1280, height: 720))
        case AVCaptureSessionPreset1920x1080:
            return squareCropRegion(for: CGSize(width: 1920, height: 1080))
        case AVCaptureSessionPreset3840x2160:
            return squareCropRegion(for: CGSize(width: 3480, height: 2160))
        default:
            return CGRect(x: 0, y: 0, width: 1, height: 1)
        }
    }
    
    func squareCropRegion(for size: CGSize) -> CGRect {
        var region = CGRect(x: 0, y: 0, width: 1, height: 1)
        region.origin.y = (size.width - size.height) / size.width / 2
        region.size.height = size.height / size.width
        return region
    }
}
