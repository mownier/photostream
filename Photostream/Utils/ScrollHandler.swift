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
    var prevContentOffsetY: CGFloat = 0.0
    var nextContentOffsetY: CGFloat = 0.0
    var offsetDelta: CGFloat {
        return abs(prevContentOffsetY) - abs(nextContentOffsetY)
    }
    var isScrollable: Bool {
        guard scrollView != nil else {
            return false
        }
        
        return scrollView!.contentSize.height > scrollView!.height
    }
    
    func isScrollingUp() -> Bool {
        guard scrollView != nil else {
            return false
        }
        
        let con1 = prevContentOffsetY > nextContentOffsetY
        let con2 = prevContentOffsetY < (scrollView!.contentSize.height - scrollView!.height)
        return con1 && con2
    }
    
    func isScrollingDown() -> Bool {
        guard scrollView != nil else {
            return false
        }
        
        let con1 = prevContentOffsetY < nextContentOffsetY
        let con2 = nextContentOffsetY > -(scrollView!.contentInset.top + scrollView!.contentInset.bottom)
        return con1 && con2
    }
}
