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
    var header: UserTimelineHeader!
    
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
        
        if view.subviews.count > 0 && view.subviews[0] is UICollectionView {
            userPostView = view.subviews[0] as? UICollectionView
            
        } else if view is UserProfileView {
            let userProfileView = view as! UserProfileView
            header.addSubview(userProfileView)
        }
    }
    
    override func layoutSubviews() {
        guard let postView = userPostView, header.userProfileView != nil else {
            return
        }
        
        var rect = header.frame
        
        rect.size.width = frame.width
        rect.size.height = header.dynamicHeight
        header.frame = rect
        
        postView.frame = bounds
        postView.scrollIndicatorInsets.top = rect.maxY
        postView.contentInset.top = rect.maxY
        
        bringSubview(toFront: header)
    }
    
    func initSetup() {
        backgroundColor = UIColor.white
    
        header = UserTimelineHeader()
        
        addSubview(header)
    }
}

extension UserTimelineView {
    
    var spacing: CGFloat {
        return 4
    }
}
