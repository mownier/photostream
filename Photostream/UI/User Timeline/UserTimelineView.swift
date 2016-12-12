//
//  UserTimelineView.swift
//  Photostream
//
//  Created by Mounir Ybanez on 12/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

protocol UserTimelineViewDelegate: class {
    
    func didSelectGrid()
    func didSelectList()
    func didSelectLiked()
}

class UserTimelineView: UIView {
    
    weak var delegate: UserTimelineViewDelegate?
    
    var userPostView: UICollectionView?
    var userProfileView: UserProfileView?
    
    var gridButton: UIButton!
    var listButton: UIButton!
    var likedButton: UIButton!
    
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
        rect.size.width /= 3
        rect.size.height = 32
        gridButton.frame = rect
        
        rect.origin.x = rect.maxX
        listButton.frame = rect
        
        rect.origin.x = rect.maxX
        likedButton.frame = rect
        
        rect.origin.x = profileView.frame.origin.x
        rect.origin.y = rect.maxY
        rect.origin.y += spacing
        rect.size.width = frame.width
        rect.size.height = frame.size.height
        rect.size.height -= rect.origin.y
        postView.frame = rect
        
        bringSubview(toFront: gridButton)
        bringSubview(toFront: listButton)
        bringSubview(toFront: likedButton)
    }
    
    func initSetup() {
        backgroundColor = UIColor.white
        
        gridButton = UIButton(type: .system)
        gridButton.setImage(#imageLiteral(resourceName: "grid_icon"), for: .normal)
        gridButton.setImage(#imageLiteral(resourceName: "grid_icon"), for: .selected)
        gridButton.addTarget(self, action: #selector(self.didTapGrid), for: .touchUpInside)
        gridButton.tintColor = UIColor(red: 10/255, green: 10/255, blue: 10/255, alpha: 1)
        
        listButton = UIButton(type: .system)
        listButton.setImage(#imageLiteral(resourceName: "list_icon"), for: .normal)
        listButton.setImage(#imageLiteral(resourceName: "list_icon"), for: .selected)
        listButton.addTarget(self, action: #selector(self.didTapList), for: .touchUpInside)
        listButton.tintColor = gridButton.tintColor

        likedButton = UIButton(type: .system)
        likedButton.setImage(#imageLiteral(resourceName: "heart"), for: .normal)
        likedButton.setImage(#imageLiteral(resourceName: "heart"), for: .selected)
        likedButton.addTarget(self, action: #selector(self.didTapLiked), for: .touchUpInside)
        likedButton.tintColor = gridButton.tintColor
        
        addSubview(gridButton)
        addSubview(listButton)
        addSubview(likedButton)
    }
}

extension UserTimelineView {
    
    func didTapGrid() {
        delegate?.didSelectGrid()
    }
    
    func didTapList() {
        delegate?.didSelectList()
    }
    
    func didTapLiked() {
        delegate?.didSelectLiked()
    }
}

extension UserTimelineView {
    
    var spacing: CGFloat {
        return 4
    }
}
