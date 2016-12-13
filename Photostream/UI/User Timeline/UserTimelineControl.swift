//
//  UserTimelineControl.swift
//  Photostream
//
//  Created by Mounir Ybanez on 12/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

protocol UserTimelineControlDelegate: class {
    
    func didSelectGrid()
    func didSelectList()
    func didSelectLiked()
}

class UserTimelineControl: UIView {

    weak var delegate: UserTimelineControlDelegate?
    
    var gridButton: UIButton!
    var listButton: UIButton!
    var likedButton: UIButton!
    var stripTopView: UIView!
    var stripBottomView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSetup()
    }
    
    override func layoutSubviews() {
        var rect = CGRect.zero
        
        rect.size.width = frame.width
        rect.size.height = 1
        stripTopView.frame = rect
        
        rect.origin.y = rect.maxY
        rect.size.width = frame.width / 3
        rect.size.height = 48
        gridButton.frame = rect
        
        rect.origin.x = rect.maxX
        listButton.frame = rect
        
        rect.origin.x = rect.maxX
        likedButton.frame = rect
        
        rect.origin.x = 0
        rect.origin.y = rect.maxY
        rect.size.width = frame.width
        rect.size.height = 1
        stripBottomView.frame = rect
    }
    
    func initSetup() {
        gridButton = UIButton()
        gridButton.setImage(#imageLiteral(resourceName: "grid_icon"), for: .normal)
        gridButton.setImage(#imageLiteral(resourceName: "grid_icon_selected"), for: .selected)
        gridButton.addTarget(self, action: #selector(self.didTapGrid), for: .touchUpInside)
        gridButton.isSelected = true
        
        listButton = UIButton()
        listButton.setImage(#imageLiteral(resourceName: "list_icon"), for: .normal)
        listButton.setImage(#imageLiteral(resourceName: "list_icon_selected"), for: .selected)
        listButton.addTarget(self, action: #selector(self.didTapList), for: .touchUpInside)
        
        likedButton = UIButton()
        likedButton.setImage(#imageLiteral(resourceName: "timeline_likes_icon"), for: .normal)
        likedButton.addTarget(self, action: #selector(self.didTapLiked), for: .touchUpInside)
        likedButton.tintColor = gridButton.tintColor
        
        stripTopView = UIView()
        stripTopView.backgroundColor = UIColor(red: 223/255, green: 223/255, blue: 223/255, alpha: 1)
        
        stripBottomView = UIView()
        stripBottomView.backgroundColor = stripTopView.backgroundColor
        
        addSubview(gridButton)
        addSubview(listButton)
        addSubview(likedButton)
        addSubview(stripTopView)
        addSubview(stripBottomView)
    }
}

extension UserTimelineControl {
    
    func didTapGrid() {
        gridButton.isSelected = true
        listButton.isSelected = false
        delegate?.didSelectGrid()
    }
    
    func didTapList() {
        gridButton.isSelected = false
        listButton.isSelected = true
        delegate?.didSelectList()
    }
    
    func didTapLiked() {
        delegate?.didSelectLiked()
    }
}
