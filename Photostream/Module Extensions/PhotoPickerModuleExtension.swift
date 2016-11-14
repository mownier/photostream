//
//  PhotoPickerModuleExtension.swift
//  Photostream
//
//  Created by Mounir Ybanez on 11/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

extension PhotoPickerWireframe {
    
    class func createViewController() -> PhotoPickerViewController {
        let sb = UIStoryboard(name: "PhotoPickerModuleStoryboard", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "PhotoPickerViewController")
        return vc as! PhotoPickerViewController
    }
    
    class func createNavigationController() -> UINavigationController {
        let sb = UIStoryboard(name: "PhotoPickerModuleStoryboard", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "PhotoPickerNavigationController")
        return vc as! UINavigationController
    }
}
