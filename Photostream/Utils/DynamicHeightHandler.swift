//
//  DynamicHeightHandler.swift
//  Photostream
//
//  Created by Mounir Ybanez on 01/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

protocol DynmaicHeightConfig: NSObjectProtocol {
    
    func computeHeight() -> CGFloat
}

struct DynamicHeightHandler {

    var heights = [CGFloat]()
}
