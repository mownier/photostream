//
//  CGRect+Extensions.swift
//  Photostream
//
//  Created by Mounir Ybanez on 14/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

extension CGRect {
    
    func fit(in rect: CGRect) -> CGRect {
        let aspectWidth: CGFloat = rect.size.width / size.width
        let aspectHeight: CGFloat = rect.size.height / size.height
        let aspectRatio: CGFloat = min(aspectWidth, aspectHeight)
        
        let width = size.width * aspectRatio
        let height = size.height * aspectRatio
        
        var newOrigin: CGPoint = .zero
        newOrigin.x = (rect.size.width - width) / 2.0
        newOrigin.y = (rect.size.height - height) / 2.0
        
        var newSize: CGSize = .zero
        newSize.width = rect.size.width - (newOrigin.x * 2)
        newSize.height = rect.size.height - (newOrigin.y * 2)
        
        let newRect = CGRect(origin: newOrigin, size: newSize)
        return newRect
    }
    
    mutating func ceil() {
        size.width = CGFloat(ceilf(Float(size.width)))
        size.height = CGFloat(ceilf(Float(size.height)))
        origin.x = CGFloat(ceilf(Float(origin.x)))
        origin.y = CGFloat(ceilf(Float(origin.y)))
    }
}
