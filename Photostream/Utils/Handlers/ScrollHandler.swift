//
//  ScrollHandler.swift
//  Photostream
//
//  Created by Mounir Ybanez on 01/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

struct ScrollHandler {

    weak var scrollView: UIScrollView?
    var offsetY: CGFloat = 0.0
    
    var offsetDelta: CGFloat {
        return abs(offsetY) - abs(currentOffsetY)
    }
    
    var isScrollable: Bool {
        guard scrollView != nil else {
            return false
        }
        
        return scrollView!.contentSize.height > scrollView!.height
    }
    
    var currentOffsetY: CGFloat {
        guard scrollView != nil else {
            return 0.0
        }
        
        return scrollView!.contentOffset.y
    }
    
    var isScrollingUp: Bool {
        guard scrollView != nil else {
            return false
        }
        
        let con1 = offsetY > currentOffsetY
        let con2 = offsetY < (scrollView!.contentSize.height - scrollView!.height)
        return con1 && con2
    }
    
    var isScrollingDown: Bool {
        guard scrollView != nil else {
            return false
        }
        
        let con1 = offsetY < currentOffsetY
        let con2 = currentOffsetY > -(scrollView!.contentInset.top + scrollView!.contentInset.bottom)
        return con1 && con2
    }
    
    mutating func update() {
        offsetY = currentOffsetY
    }
}
