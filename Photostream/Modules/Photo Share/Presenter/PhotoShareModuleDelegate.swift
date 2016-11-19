//
//  PhotoShareModuleDelegate.swift
//  Photostream
//
//  Created by Mounir Ybanez on 19/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

protocol PhotoShareModuleDelegate: class {

    func photoShareDidCancel()
    func photoShareDidFinish(with image: UIImage, content: String)
}
