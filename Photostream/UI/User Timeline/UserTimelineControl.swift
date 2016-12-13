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
        delegate?.didSelectGrid()
    }
    
    func didTapList() {
        delegate?.didSelectList()
    }
    
    func didTapLiked() {
        delegate?.didSelectLiked()
    }
}
