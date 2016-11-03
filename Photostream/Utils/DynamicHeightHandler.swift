//
//  DynamicHeightHandler.swift
//  Photostream
//
//  Created by Mounir Ybanez on 01/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

protocol DynamicCellDelegate: class {
    
    var dynamicHeight: CGFloat { set get }
}

protocol DynamicCellHandler {
    
    var cell: CellType? { set get }
    var heights: [KeyType: CGFloat]! { set get }
    
    associatedtype KeyType: Hashable
    associatedtype CellType
}

protocol DynamicHeight: class {
    
    func configure(for post: Item)
    
    associatedtype Item
}
