//
//  CommentFeedEmptyView.swift
//  Photostream
//
//  Created by Mounir Ybanez on 29/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class CommentFeedEmptyView: UIView {
    
    var messageLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSetup()
    }
    
    func initSetup() {
        messageLabel = UILabel()
        messageLabel.textAlignment = .center
        
        addSubview(messageLabel)
    }
    
    override func layoutSubviews() {
        messageLabel.frame.size = CGSize(width: frame.width - (2 * 8), height: 21)
        messageLabel.center = center
    }
}
