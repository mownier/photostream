//
//  PhotoCaptureViewController.swift
//  Photostream
//
//  Created by Mounir Ybanez on 10/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit
import GPUImage

class PhotoCaptureViewController: UIViewController {

    @IBOutlet weak var preview: GPUImageView!
    @IBOutlet weak var controlContentView: UIView!
    @IBOutlet weak var captureButton: UIButton!
    
    lazy var camera = GPUImageStillCamera(sessionPreset: AVCaptureSessionPreset640x480, cameraPosition: .back)!
    lazy var filter = GPUImageBrightnessFilter()
    
    var presenter: PhotoCaptureModuleInterface!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCamera()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        startCamera()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        stopCamera()
        
        super.viewWillDisappear(animated)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func didTapCapture() {
        // TODO: Implement image capture
        presenter.capture()
        dismiss(animated: true, completion: nil)
    }
    
    func setupCamera() {
        guard isCameraAvailable else {
            return
        }
        
        camera.outputImageOrientation = .portrait
        preview.fillMode = kGPUImageFillModePreserveAspectRatioAndFill
        filter.addTarget(preview)
        camera.addTarget(filter)
    }
    
    func startCamera() {
        guard isCameraAvailable else {
            return
        }
        
        camera.startCapture()
    }
    
    func stopCamera() {
        guard isCameraAvailable else {
            return
        }
        
        camera.stopCapture()
    }
}

extension PhotoCaptureViewController: PhotoCaptureViewInterface {
    
    var controller: UIViewController? {
        return self
    }
    
    var isCameraAvailable: Bool {
        return UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    func capturedImage(with result: @escaping (UIImage?) -> Void) {
        guard isCameraAvailable else {
            result(nil)
            return
        }
        
        camera.capturePhotoAsImageProcessedUp(toFilter: filter) { (image, error) in
            result(image)
        }
    }
}
