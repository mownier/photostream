//
//  UITextField+Extensions.swift
//  Photostream
//
//  Created by Mounir Ybanez on 15/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

extension UITextField {

    @IBInspectable var placeholderColor: UIColor? {
        set {
            if let newValue = newValue {
                attributedPlaceholder = NSAttributedString(string: placeholder!, attributes:[NSForegroundColorAttributeName: newValue])
            }
        }
        get {
            let attr = attributedPlaceholder?.attributesAtIndex(0, longestEffectiveRange: nil, inRange: NSMakeRange(0, attributedPlaceholder!.length))
            return attr?[NSForegroundColorAttributeName] as? UIColor
        }
    }
}

extension UITextField {

    @IBInspectable var paddingLeft: CGFloat {
        set {
            var left: CGFloat = 0
            if newValue > 0 {
                left = newValue
            }
            let view = UIView(frame: CGRectMake(0, 0, left, height))
            leftView = view
            leftViewMode = .Always
        }
        get {
            if let leftView = leftView {
                return leftView.width
            } else {
                return 0
            }
        }
    }
}
