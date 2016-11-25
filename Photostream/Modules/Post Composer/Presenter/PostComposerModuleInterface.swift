//
//  PhotoPickerModuleInterface.swift
//  Photostream
//
//  Created by Mounir Ybanez on 09/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

protocol PhotoPickerModuleInterface: class {
    
    func cancelWriting()
    func doneWriting(with image: UIImage, content: String)
    
    func willShowCamera()
    func willShowLibrary()
    
    func dismiss(animated: Bool)
}

extension PhotoPickerModuleInterface {
    
    func dismiss() {
        dismiss(animated: true)
    }
}
