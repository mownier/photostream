//
//  PhotoShareModuleInterface.swift
//  Photostream
//
//  Created by Mounir Ybanez on 18/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

protocol PhotoShareModuleInterface: class {

    func cancel()
    func finish(with image: UIImage, content: String)
    
    func pop(animated: Bool)
    func dismiss(animated: Bool, completion: (() -> Void)?)
}

extension PhotoShareModuleInterface {
    
    func pop() {
        pop(animated: true)
    }
    
    func dismiss() {
        dismiss(animated: true, completion: nil)
    }
}
