//
//  PhotoPickerModuleInterface.swift
//  Photostream
//
//  Created by Mounir Ybanez on 11/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit
import Photos

protocol PhotoPickerModuleInterface: class {

    func fetchImageAssets()
    
    func photo(at index: Int) -> PHAsset?
}
