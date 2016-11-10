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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func didTapCapture() {

    }
}
