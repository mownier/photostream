//
//  MultilineEditorView.swift
//  Photostream
//
//  Created by Mounir Ybanez on 16/01/2017.
//  Copyright © 2017 Mounir Ybanez. All rights reserved.
//

import UIKit

class MultilineEditorView: UIView {

    var textView: UITextView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSetup()
    }
    
    func initSetup() {
        textView = UITextView()
        
        addSubview(textView)
    }
    
    override func layoutSubviews() {
        textView.frame = bounds
    }
}
