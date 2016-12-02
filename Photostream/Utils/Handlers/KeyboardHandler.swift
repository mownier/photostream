//
//  KeyboardHandler.swift
//  Photostream
//
//  Created by Mounir Ybanez on 02/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

fileprivate enum Direction {
    case up
    case down
}

struct KeyboardHandler {

    var willMoveUp: ((CGFloat) -> Void)?
    var willMoveDown: ((CGFloat) -> Void)?
    var info: [AnyHashable: Any]?
    
    func handle(using view: UIView, with animation: @escaping (CGFloat) -> Void) {
        guard let userInfo = info,
            let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt,
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double,
            let frameEnd = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue,
            let frameBegin = userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue,
            let direction = direction(end: frameEnd, begin: frameBegin),
            let window = view.window,
            let superview = view.superview else {
            return
        }
        
        let rectEnd = frameEnd.cgRectValue
        let rectBegin = frameBegin.cgRectValue
        
        let options = UIViewAnimationOptions(rawValue: curve << 16)
        let rectWindow = view.convert(CGRect.zero, to: nil)
        
        var offsetY = rectEnd.origin.y - rectBegin.origin.y
        var insetBottom = window.bounds.size.height - rectWindow.origin.y
        
        switch direction {
        case .up:
            insetBottom -= view.bounds.size.height
            offsetY += insetBottom
            willMoveUp?(offsetY)
        case .down:
            insetBottom += view.frame.origin.y
            insetBottom -= superview.bounds.size.height
            offsetY -= insetBottom
            willMoveDown?(offsetY)
        }
        
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: options,
            animations: {
                animation(offsetY)
            },
            completion: nil
        )
    }
    
    private func direction(end frameEnd: NSValue, begin frameBegin: NSValue) -> Direction? {
        let rectEnd = frameEnd.cgRectValue
        let rectBegin = frameBegin.cgRectValue
        
        if rectEnd.origin.y < rectBegin.origin.y {
            return .up
            
        } else if rectEnd.origin.y > rectBegin.origin.y {
            return .down
        
        } else {
            return nil
        }
    }
}
