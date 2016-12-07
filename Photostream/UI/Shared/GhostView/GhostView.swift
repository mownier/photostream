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
        titleLabel.frame = rect
        titleLabel.center = center
    }
}

extension GhostView {
    
    fileprivate var spacing: CGFloat {
        return 4
    }
}
