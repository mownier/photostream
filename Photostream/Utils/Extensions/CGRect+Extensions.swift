//
//  CGRect+Extensions.swift
//  Photostream
//
//  Created by Mounir Ybanez on 14/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

extension CGRect {
    
    private func newRect(in rect: CGRect, for aspectRatio: CGFloat) -> CGRect {
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
    
    private func aspectWidth(for rect: CGRect) -> CGFloat {
        return rect.size.width / size.width
    }
    
    private func aspectHeight(for rect: CGRect) -> CGFloat {
        return rect.size.height / size.height
    }
    
    func fit(in rect: CGRect) -> CGRect {
        let aspectRatio: CGFloat = min(aspectWidth(for: rect), aspectHeight(for: rect))
        return newRect(in: rect, for: aspectRatio)
    }
    
    func fill(in rect: CGRect) -> CGRect {
        let aspectRatio: CGFloat = max(aspectWidth(for: rect), aspectHeight(for: rect))
        return newRect(in: rect, for: aspectRatio)
    }
    
    mutating func ceil() {
        size.width = CGFloat(ceilf(Float(size.width)))
        size.height = CGFloat(ceilf(Float(size.height)))
        origin.x = CGFloat(ceilf(Float(origin.x)))
        origin.y = CGFloat(ceilf(Float(origin.y)))
    }
}
