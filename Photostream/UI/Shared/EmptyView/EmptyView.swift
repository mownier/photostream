//
//  EmptyView.swift
//  Photostream
//
//  Created by Mounir Ybanez on 08/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class EmptyView: UIView, EmptyViewInterface {

    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var subtitleLabel: UILabel?
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var actionButton: UIButton?
    
    var actionHandler: (EmptyViewInterface)?
}

extension EmptyView {
    
    class func createNew() -> EmptyView {
        let main = Bundle.main
        let views = main.loadNibNamed("EmptyView", owner: nil, options: nil)!
        let emptyView = views[0]
        
        return emptyView as! EmptyView
    }
}
