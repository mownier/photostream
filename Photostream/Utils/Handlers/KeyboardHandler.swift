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

struct KeyboardFrameDelta {
    
    var height: CGFloat = 0
    var y: CGFloat = 0
}

struct KeyboardHandler {

    var willMoveUp: ((KeyboardFrameDelta) -> Void)?
    var willMoveDown: ((KeyboardFrameDelta) -> Void)?
    var info: [AnyHashable: Any]?
    
    func handle(using view: UIView, with animation: @escaping (KeyboardFrameDelta) -> Void) {
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
        
        var insetBottom = window.bounds.size.height - rectWindow.origin.y
        var delta = KeyboardFrameDelta()
        delta.height = rectEnd.size.height - rectBegin.size.height
        delta.y = rectEnd.origin.y - rectBegin.origin.y
        
        switch direction {
        case .up:
            insetBottom -= view.bounds.size.height
            delta.y += insetBottom
            willMoveUp?(delta)
        case .down:
            insetBottom += view.frame.origin.y
            insetBottom -= superview.bounds.size.height
            delta.y -= insetBottom
            willMoveDown?(delta)
        }
        
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: options,
            animations: {
                animation(delta)
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
