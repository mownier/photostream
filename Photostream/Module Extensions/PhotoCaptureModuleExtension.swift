//
//  PhotoCaptureModuleExtension.swift
//  Photostream
//
//  Created by Mounir Ybanez on 10/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

extension PhotoCaptureWireframe {
    
    class func createViewController() -> PhotoCaptureViewController {
        let sb = UIStoryboard(name: "PhotoCaptureModuleStoryboard", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "PhotoCaptureViewController")
        return vc as! PhotoCaptureViewController
    }
}
