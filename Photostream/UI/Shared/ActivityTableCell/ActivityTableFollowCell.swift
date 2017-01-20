//
//  ActivityTableFollowCell.swift
//  Photostream
//
//  Created by Mounir Ybanez on 27/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

protocol ActivityTableFollowCellDelegate: class {
    
    func didTapAction(cell: ActivityTableFollowCell)
    func didTapAvatar(cell: UITableViewCell)
}

class ActivityTableFollowCell: UITableViewCell {

    weak var delegate: ActivityTableFollowCellDelegate?
    
    var avatarImageView: UIImageView!
    var contentLabel: UILabel!
    var actionButton: UIButton!
    
    convenience init() {
        self.init(style: .default, reuseIdentifier: ActivityTableCommentCell.reuseId)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSetup()
    }
    
    fileprivate func initSetup() {
        avatarImageView = UIImageView()
        avatarImageView.cornerRadius = avatarDimension / 2
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.backgroundColor = .lightGray
        
        contentLabel = UILabel()
        contentLabel.numberOfLines = 0
        contentLabel.font = UIFont.systemFont(ofSize: 12)
        
        actionButton = UIButton()
        actionButton.addTarget(self, action: #selector(self.didTapAction), for: .touchUpInside)
        actionButton.setImage(#imageLiteral(resourceName: "activity_follow_action_button_black"), for: .normal)
        actionButton.cornerRadius = 2
        actionButton.borderWidth = 1
        actionButton.borderColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1)
        
        addSubview(avatarImageView)
        addSubview(contentLabel)
        addSubview(actionButton)
    }
    
    override func layoutSubviews() {
        var rect = CGRect.zero
        
        rect.origin.x = spacing
        rect.origin.y = (frame.height - avatarDimension) / 2
        rect.size.width = avatarDimension
        rect.size.height = avatarDimension
        avatarImageView.frame = rect
        
        rect.origin.x = frame.width - actionButtonSize.width - spacing
        rect.origin.y = (frame.height - actionButtonSize.height) / 2
        rect.size = actionButtonSize
        actionButton.frame = rect
        
        rect.origin.x = avatarImageView.frame.maxX
        rect.origin.x += spacing
        rect.size.width = frame.width - rect.origin.x
        rect.size.width -= actionButton.frame.width
        rect.size.width -= (spacing * 2)
        rect.size.height = contentLabel.sizeThatFits(rect.size).height
        rect.origin.y = (frame.height - rect.size.height) / 2
        contentLabel.frame = rect
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTapAvatar))
        tap.numberOfTapsRequired = 1
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(tap)
    }
}

extension ActivityTableFollowCell {
    
    func didTapAction() {
        delegate?.didTapAction(cell: self)
    }
    
    func didTapAvatar() {
        delegate?.didTapAvatar(cell: self)
    }
}

extension ActivityTableFollowCell {
    
    var spacing: CGFloat {
        return 4
    }
    
    var avatarDimension: CGFloat {
        return 32
    }
    
    var actionButtonSize: CGSize {
        return CGSize(width: 44, height: 22)
    }
}

extension ActivityTableFollowCell {
    
    static var reuseId: String {
        return "ActivityTableFollowCell"
    }
}

extension ActivityTableFollowCell {
    
    class func dequeue(from view: UITableView) -> ActivityTableFollowCell? {
        return view.dequeueReusableCell(withIdentifier: self.reuseId) as? ActivityTableFollowCell
    }
    
    class func register(in view: UITableView) {
        view.register(self, forCellReuseIdentifier: self.reuseId)
    }
}
