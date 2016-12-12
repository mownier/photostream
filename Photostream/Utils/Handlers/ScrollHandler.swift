//
//  ScrollHandler.swift
//  Photostream
//
//  Created by Mounir Ybanez on 01/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

protocol ScrollEventListener: class {
    
    func didScrollUp(with delta: CGFloat, offsetY: CGFloat)
    func didScrollDown(with delta: CGFloat, offsetY: CGFloat)
}

enum ScrollDirection {
    case none
    case down
    case up
}

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
        
        return scrollView!.contentSize.height > scrollView!.height - scrollView!.contentInset.top
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
    
    var maximumOffsetY: CGFloat {
        guard scrollView != nil else {
            return 0
        }
        
        return scrollView!.contentSize.height - scrollView!.frame.height
    }
    
    var percentageOffsetY: CGFloat {
        guard scrollView != nil else {
            return 0
        }
        
        let offset = scrollView!.contentOffset.y + scrollView!.contentInset.top
        let percentage = min(abs(offset / maximumOffsetY), 1.0)
        return offset > 0 ? percentage : 0
    }
    
    var isBottomReached: Bool {
        guard scrollView != nil else {
            return false
        }
        
        return currentOffsetY + scrollView!.frame.height >= scrollView!.contentSize.height
    }
    
    var direction: ScrollDirection {
        if isScrollingDown {
            return .down
            
        } else if isScrollingUp {
            return .up
        }
        
        return .none
    }
    
    mutating func update() {
        offsetY = currentOffsetY
    }
    
    func killScroll() {
        guard scrollView != nil else {
            return
        }
        
        scrollView!.setContentOffset(scrollView!.contentOffset, animated: false)
    }
}
