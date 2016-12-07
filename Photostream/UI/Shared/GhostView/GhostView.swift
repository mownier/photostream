//
//  GhostView.swift
//  Photostream
//
//  Created by Mounir Ybanez on 07/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class GhostView: UIView {

    var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSetup()
    }
    
    func initSetup() {
        titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        addSubview(titleLabel)
    }
    
    override func layoutSubviews() {
        var rect = CGRect.zero
        rect.size.width = frame.width - (spacing * 4)
        rect.size.height = titleLabel.sizeThatFits(frame.size).height
        rect.origin.x = (frame.width - rect.size.width) / 2
        rect.origin.y = (frame.height - rect.size.height) / 2
        titleLabel.frame = rect
    }
}

extension GhostView {
    
    fileprivate var spacing: CGFloat {
        return 4
    }
}
