//
//  UICollectionViewExtension.swift
//  Photostream
//
//  Created by Mounir Ybanez on 05/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    subscript(cell: UICollectionViewCell) -> IndexPath? {
        return indexPath(for: cell)
    }
}
