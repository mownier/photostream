//
//  UserTimelineHeader.swift
//  Photostream
//
//  Created by Mounir Ybanez on 13/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class UserTimelineHeader: UIView {
    
    var control: UserTimelineControl!
    var userProfileView: UserProfileView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSetup()
    }
    
    override func addSubview(_ view: UIView) {
        super.addSubview(view)
        
        if view is UserProfileView {
            userProfileView = view as? UserProfileView
        }
    }
    
    override func layoutSubviews() {
        guard let profileView = userProfileView else {
            return
        }
        
        var rect = profileView.bounds
        
        rect.size.width = frame.width
        rect.size.height = profileView.dynamicHeight
        profileView.frame = rect
        
        rect.origin.y = rect.maxY
        rect.origin.y += spacing
        rect.size.height = 50
        control.frame = rect
    }
    
    func initSetup() {
        backgroundColor = UIColor.white
        
        control = UserTimelineControl()
        
        addSubview(control)
    }
}

extension UserTimelineHeader {
    
    var spacing: CGFloat {
        return 4
    }
    
    var dynamicHeight: CGFloat {
        return control.frame.maxY
    }
}
