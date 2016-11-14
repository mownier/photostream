//
//  UIView+Extensions.swift
//  Photostream
//
//  Created by Mounir Ybanez on 15/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

extension UIView {

    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
}

extension UIView {

    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var borderColor: UIColor {
        set {
            layer.borderColor = newValue.cgColor
        }
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
    }
}

extension UIView {

    var width: CGFloat {
        get {
            return frame.size.width
        }
    }

    var height: CGFloat {
        get {
            return frame.size.height
        }
    }

    var posX: CGFloat {
        get {
            return frame.origin.x
        }
    }

    var posY: CGFloat {
        get {
            return frame.origin.y
        }
    }
}

extension UIView {

    func addSubviewAtCenter(_ subview: UIView!) {
        let centerX = (width - subview.width) / 2
        let centerY = (height - subview.height) / 2
        let centerFrame = CGRect(x: centerX, y: centerY, width: subview.width, height: subview.height)
        subview.frame = centerFrame
        addSubview(subview)
    }
}

extension UIView {

    func createImage() -> UIImage! {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
}

extension UIView {
    
    func removeAllSubviews() {
        subviews.forEach { (subview) in
            subview.removeFromSuperview()
        }
    }
}
