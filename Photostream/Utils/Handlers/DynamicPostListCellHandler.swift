//
//  DynamicPostListCellHandler.swift
//  Photostream
//
//  Created by Mounir Ybanez on 03/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

struct DynamicPostListCellHandler: DynamicCellHandler {
    
    typealias KeyType = String
    typealias CellType = PostListCell
    
    var cell: CellType?
    var heights: [KeyType: CGFloat]! = [KeyType: CGFloat]()
}
