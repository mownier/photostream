//
//  ActivityTableLikeCell.swift
//  Photostream
//
//  Created by Mounir Ybanez on 23/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class ActivityTableLikeCell: UITableViewCell {
    
    var avatarImageView: UIImageView!
    var photoImageView: UIImageView!
    var contentLabel: UILabel!
    
    convenience init() {
        self.init(style: .default, reuseIdentifier: ActivityTableLikeCell.reuseId)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSetup()
    }
    
    func initSetup() {
        avatarImageView = UIImageView()
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.backgroundColor = UIColor.lightGray
        avatarImageView.cornerRadius = avatarDimension / 2
        
        photoImageView = UIImageView()
        photoImageView.contentMode = .scaleAspectFit
        photoImageView.backgroundColor = UIColor.lightGray
        
        contentLabel = UILabel()
        contentLabel.numberOfLines = 0
        contentLabel.font = UIFont.systemFont(ofSize: 14)
        
        addSubview(avatarImageView)
        addSubview(photoImageView)
        addSubview(contentLabel)
    }
    
    override func layoutSubviews() {
        var rect = CGRect.zero
        
        rect.origin.x = spacing
        rect.origin.y = (frame.height - avatarDimension) / 2
        rect.size.width = avatarDimension
        rect.size.height = avatarDimension
        avatarImageView.frame = rect
        
        rect.origin.x = frame.width - photoDimension - spacing
        rect.origin.y = (frame.height - photoDimension) / 2
        rect.size.width = photoDimension
        rect.size.height = photoDimension
        photoImageView.frame = rect
        
        rect.origin.x = avatarImageView.frame.maxX
        rect.origin.x += spacing
        rect.size.width = frame.width - rect.origin.x
        rect.size.width -= photoImageView.frame.width
        rect.size.width -= (spacing * 2)
        rect.size.height = contentLabel.sizeThatFits(rect.size).height
        rect.origin.y = (frame.height - rect.size.height) / 2
        contentLabel.frame = rect
    }
}

extension ActivityTableLikeCell {
    
    var spacing: CGFloat {
        return 4
    }
    
    var avatarDimension: CGFloat {
        return 32
    }
    
    var photoDimension: CGFloat {
        return 32
    }
}

extension ActivityTableLikeCell {
    
    static var reuseId: String {
        return "ActivityTableLikeCell"
    }
}

extension ActivityTableLikeCell {
    
    class func dequeue(from view: UITableView) -> ActivityTableLikeCell? {
        return view.dequeueReusableCell(withIdentifier: self.reuseId) as? ActivityTableLikeCell
    }
    
    class func register(in view: UITableView) {
        view.register(self, forCellReuseIdentifier: self.reuseId)
    }
}

