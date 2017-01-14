//
//  CropView.swift
//  Photostream
//
//  Created by Mounir Ybanez on 15/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

enum CropViewContent {
    
    case fit, fill
}

class CropView: UIScrollView {
    
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
        contentInset.left = 0
        contentInset.top = 0
    }
    
    func setCropTarget(with image: UIImage?, content: CropViewContent = .fit) {
        guard let image = image else {
            return
        }
        
        setupDefaults()
        
        let imageRect = CGRect(origin: .zero, size: image.size)
        
        var rect = CGRect.zero
        
        switch content {
            
        case .fit:
            rect = imageRect.fit(in: bounds)
        
        case .fill:
            rect = imageRect.fill(in: bounds)
        }
        
        rect.ceil()
        
        imageView.frame = rect
        imageView.image = image
        
        contentSize = rect.size
        adjustContent()
    }
    
    fileprivate func adjustContent() {
        if imageView.frame.width > bounds.width {
            contentSize.width -= abs(imageView.frame.origin.x)
            contentInset.left = abs(imageView.frame.origin.x)
        }
        
        if imageView.frame.height > bounds.height {
            contentSize.height -= abs(imageView.frame.origin.y)
            contentInset.top = abs(imageView.frame.origin.y)
        }
    }
}

extension CropView: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        imageView.frame.origin = pointOnZoom
        
        if zoomScale > minimumZoomScale {
            contentSize = imageView.frame.size
            contentInset.left = 0
            contentInset.top = 0
            
        } else {
           adjustContent()
        }
    }
}

extension CropView {
    
    var zoomFillScale: CGFloat {
        let imageViewSize = imageView.frame.size
        let cropViewSize = frame.size
        var fillScale: CGFloat = zoomScale
        
        // If image view's width is less than the height,
        // the scale will be relative to the width.
        // Otherwise to the height.
        if imageViewSize.width < imageViewSize.height {
            // Fill Scale (FS)
            // Crop View Width (CVW)
            // Image View Height (IVW)
            // Constant Multipler (K)
            //
            // FS = K * (CVW / IVW)
            //
            // If image view's width is less than the crop view's width
            // and the zoom scale is at minimum, 
            // `K` will be the minimum zoom scale.
            // Otherwise, `K` will be the zoom scale.
            if imageViewSize.width < cropViewSize.width && zoomScale == minimumZoomScale {
                fillScale = minimumZoomScale * (cropViewSize.width / imageViewSize.width)
            } else {
                fillScale = zoomScale * (cropViewSize.width / imageViewSize.width)
            }
        } else {
            if imageViewSize.height < cropViewSize.height && fillScale == minimumZoomScale {
                fillScale = minimumZoomScale * (cropViewSize.height / imageViewSize.height)
            } else {
                fillScale = zoomScale * (cropViewSize.height / imageViewSize.height)
            }
        }
        
        return fillScale
    }
    
    func zoomToFill(_ animated: Bool = false) {
        setZoomScale(zoomFillScale, animated: animated)
    }
    
    func zoomToFit(_ animated: Bool = false) {
        setZoomScale(1.0, animated: animated)
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

extension CropView {
    
    // Inspired by https://github.com/wenzhaot/InstagramPhotoPicker
    
    var croppedImage: UIImage? {
        var rect = visibleRect
        let transform = rectTransform
        rect = rect.applying(transform)
        
        guard let scale = imageView.image?.scale,
            let orientation = imageView.image?.imageOrientation,
            let ref = imageView.image?.cgImage?.cropping(to: rect) else {
            return nil
        }
        
        let image = UIImage(cgImage: ref, scale: scale, orientation: orientation)
        return image
    }
    
    var visibleRect: CGRect {
        guard let imageWidth = imageView.image?.size.width,
            imageView.frame.size.width > 0 else {
            return .zero
        }
        
        var sizeScale = imageWidth / imageView.frame.size.width
        sizeScale *= zoomScale
        var rect = convert(bounds, to: imageView)
        rect.origin.x *= sizeScale
        rect.origin.y *= sizeScale
        rect.size.width *= sizeScale
        rect.size.height *= sizeScale
        return rect
    }
    
    var rectTransform: CGAffineTransform {
        guard let orientation = imageView.image?.imageOrientation,
            let scale = imageView.image?.scale,
            let width = imageView.image?.size.width,
            let height = imageView.image?.size.height else {
            return CGAffineTransform.identity
        }
        
        var transform = CGAffineTransform()
        switch orientation {
        case .left:
            transform = transform.rotated(by: radians(90)).translatedBy(x: 0, y: -height)
        case .right:
            transform = transform.rotated(by: radians(-90)).translatedBy(x: -width, y: 0)
        case .down:
            transform = transform.rotated(by: radians(-180)).translatedBy(x: -width, y: -height)
        default:
            transform = CGAffineTransform.identity
        }
        
        transform = transform.scaledBy(x: scale, y: scale)
        return transform
    }
    
    func radians(_ degrees: Int) -> CGFloat {
        return CGFloat(CGFloat(degrees) * .pi / 180)
    }
}

extension CropView: PhotoCropper {
    
    var image: UIImage? {
        return croppedImage
    }
}
