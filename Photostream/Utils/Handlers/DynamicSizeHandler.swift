//
//  DynamicSizeHandler.swift
//  Photostream
//
//  Created by Mounir Ybanez on 01/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

protocol DynamicSizeable {
    
    var bounds: CGRect { set get }
    var contentView: UIView { get }
    
    func setNeedsLayout()
    func layoutIfNeeded()
}

struct DynamicSizeHandler<P:Hashable, S:Hashable> {
    
    var prototypes: [P: DynamicSizeable] = [P: DynamicSizeable]()
    var sizes: [S: CGSize] = [S: CGSize]()
    
    mutating func compute(for key: S, with reuseId: P, config: (DynamicSizeable) -> CGSize) -> CGSize {
        guard sizes[key] == nil else {
            return sizes[key]!
        }
        
        guard var prototype = prototypes[reuseId] else {
            return .zero
        }
        
        let targetSize = config(prototype)
        let bounds = CGRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height)
        prototype.bounds = bounds
        prototype.contentView.bounds = bounds
        prototype.setNeedsLayout()
        prototype.layoutIfNeeded()
        
        let size = prototype.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        sizes[key] = size
        
        return size
    }
    
    mutating func register(prototype: DynamicSizeable, for reuseId: P) {
        prototypes[reuseId] = prototype
    }
    
    mutating func recompute() {
        sizes.removeAll()
    }
}
