//
//  PhotoPickerViewInterface.swift
//  Photostream
//
//  Created by Mounir Ybanez on 09/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

protocol PhotoPickerViewInterface: class {

    var controller: UIViewController? { get }
    var presenter: PhotoPickerModuleInterface! { set get }
    
    func setupDependency(with controllers: [UIViewController])
    
    func showCamera()
    func showLibrary()
}
