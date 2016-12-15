//
//  KeyboardHandler.swift
//  Photostream
//
//  Created by Mounir Ybanez on 02/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

enum KeyboardDirection {
    
    case none
    case up
    case down
}

struct KeyboardFrameDelta {
    
    var height: CGFloat = 0
    var y: CGFloat = 0
    var direction: KeyboardDirection = .none
}

struct KeyboardHandler {

    var willMoveUp: ((KeyboardFrameDelta) -> Void)?
    var willMoveDown: ((KeyboardFrameDelta) -> Void)?
    var info: [AnyHashable: Any]?
    var willMoveUsedView: Bool = true
    
    func handle(using view: UIView, with animation: ((KeyboardFrameDelta) -> Void)? = nil) {
        guard let userInfo = info,
            let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt,
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double,
            let frameEnd = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue,
            let frameBegin = userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue,
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
        delta.direction = direction(end: frameEnd, begin: frameBegin)
        delta.height = rectEnd.size.height - rectBegin.size.height
        delta.y = rectEnd.origin.y - rectBegin.origin.y
        
        switch delta.direction {
        case .up:
            insetBottom -= view.bounds.size.height
            delta.y += insetBottom
            willMoveUp?(delta)
        case .down:
            insetBottom += view.frame.origin.y
            insetBottom -= superview.bounds.size.height
            delta.y -= insetBottom
            willMoveDown?(delta)
        default:
            break
        }
        
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: options,
            animations: {
                if self.willMoveUsedView {
                    if delta.height == 0 {
                        view.frame.origin.y += delta.y
                    } else {
                        view.frame.origin.y -= delta.height
                    }
                }
                animation?(delta)
            },
            completion: nil
        )
    }
    
    private func direction(end frameEnd: NSValue, begin frameBegin: NSValue) -> KeyboardDirection {
        let rectEnd = frameEnd.cgRectValue
        let rectBegin = frameBegin.cgRectValue
        
        if rectEnd.origin.y < rectBegin.origin.y {
            return .up
            
        } else if rectEnd.origin.y > rectBegin.origin.y {
            return .down
        
        } else {
            return .none
        }
    }
}
