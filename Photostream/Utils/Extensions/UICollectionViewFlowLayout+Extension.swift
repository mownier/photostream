//
//  UICollectionViewFlowLayout+Extension.swift
//  Photostream
//
//  Created by Mounir Ybanez on 15/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

extension UICollectionViewFlowLayout {

    func configure(with width: CGFloat, columnCount: Int, columnSpacing: CGFloat = 0.25, rowSpacing: CGFloat = 1.0) {
        let totalColumnSpacing = columnSpacing * CGFloat((columnCount - 1))
        let side = (width / CGFloat(columnCount)) - totalColumnSpacing
        itemSize = CGSize(width: side, height: side)
        minimumInteritemSpacing = columnSpacing
        minimumLineSpacing = rowSpacing
    }
}
