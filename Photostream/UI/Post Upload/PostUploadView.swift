//
//  PostUploadView.swift
//  Photostream
//
//  Created by Mounir Ybanez on 23/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class PostUploadView: UIView {
    
    fileprivate let uniformLength: CGFloat = 44
    fileprivate let uniformSpacing: CGFloat = 4
    fileprivate var fixHeight: CGFloat {
        return uniformSpacing + (uniformLength * 2)
    }
    
    var imageView: UIImageView!
    var progressView: UIProgressView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSetup()
    }
    
    override func layoutSubviews() {
        var rect = CGRect(x: uniformSpacing, y: uniformSpacing, width: uniformLength, height: uniformLength)
        imageView.frame = rect
        
        rect = progressView.frame
        rect.origin.x = uniformLength + (uniformSpacing * 2)
        rect.origin.y = imageView.center.y
        rect.size.width = frame.size.width - (uniformLength + (uniformSpacing * 3))
        progressView.frame = rect
    }
    
    func initSetup() {
        backgroundColor = UIColor.white
        
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.lightGray
        
        progressView = UIProgressView()
        progressView.tintColor = UIColor(red: 10/255, green: 10/255, blue: 10/255, alpha: 1.0)
        
        addSubview(imageView)
        addSubview(progressView)
    }
}
