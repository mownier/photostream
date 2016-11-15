//
//  CropView.swift
//  Photostream
//
//  Created by Mounir Ybanez on 15/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class CropView: UIScrollView, UIScrollViewDelegate {
    
    var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSetup()
    }
    
    func initSetup() {
        imageView = UIImageView()
        imageView.backgroundColor = UIColor.green
        addSubview(imageView)
        delegate = self
        minimumZoomScale = 1.0
        maximumZoomScale = 2.0
    }
    
    func setupDefaults() {
        contentSize = bounds.size
        zoomScale = 1.0
    }
    
    func setCropTarget(with image: UIImage?) {
        guard let image = image else {
            return
        }
        
        setupDefaults()
        
        let imageRect = CGRect(origin: .zero, size: image.size)
        var fitRect = imageRect.fit(in: bounds)
        fitRect.ceil()
        
        imageView.frame = fitRect
        imageView.image = image
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        imageView.frame.origin = pointOnZoom
    }
}

extension CropView {
    
    var isImageViewSizeFitEnough: (Bool, Bool) {
        let contentSize = imageView.frame.size
        let containerSize = bounds.size
        
        let isWidthFitEnough = contentSize.width < containerSize.width
        let isHeightFitEnough = contentSize.height < containerSize.height
        
        return (isWidthFitEnough, isHeightFitEnough)
    }
    
    var pointOnZoom: CGPoint {
        let (isWidthFitEnough, isHeightFitEnough) = isImageViewSizeFitEnough
        
        var point: CGPoint = .zero
        if isWidthFitEnough {
            point.x = (bounds.width - imageView.frame.size.width) / 2.0
        }
        
        if isHeightFitEnough {
            point.y = (bounds.height - imageView.frame.size.height) / 2.0
        }
        
        return point
    }
}
