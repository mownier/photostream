//
//  UserTimelineView.swift
//  Photostream
//
//  Created by Mounir Ybanez on 12/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class UserTimelineView: UIView {
    
    var userPostView: UICollectionView?
    var userProfileView: UserProfileView?
    
    var control: UserTimelineControl!
    
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
            
        } else if view.subviews.count > 0 && view.subviews[0] is UICollectionView {
            userPostView = view.subviews[0] as? UICollectionView
        }
    }
    
    override func layoutSubviews() {
        guard let postView = userPostView, let profileView = userProfileView else {
            return
        }
        
        var rect = profileView.frame
        
        rect.size.width = frame.width
        rect.size.height = profileView.dynamicHeight
        profileView.frame = rect

        rect.origin.y = rect.maxY
        rect.origin.y += spacing
        rect.size.height = 50
        control.frame = rect
        
        rect.origin.x = profileView.frame.origin.x
        rect.origin.y = rect.maxY
        rect.size.width = frame.width
        rect.size.height = frame.size.height
        rect.size.height -= rect.origin.y
        postView.frame = rect
        
        bringSubview(toFront: control)
    }
    
    func initSetup() {
        backgroundColor = UIColor.white
        
        control = UserTimelineControl()
        addSubview(control)
    }
}

extension UserTimelineView {
    
    var spacing: CGFloat {
        return 4
    }
}
