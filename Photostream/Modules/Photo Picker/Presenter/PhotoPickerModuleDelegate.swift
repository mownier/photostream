//
//  PhotoPickerModuleDelegate.swift
//  Photostream
//
//  Created by Mounir Ybanez on 11/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

protocol PhotoPickerModuleDelegate: class {

    func photoPickerDidPick(with image: UIImage?)
    func photoPickerDidCancel()
}
