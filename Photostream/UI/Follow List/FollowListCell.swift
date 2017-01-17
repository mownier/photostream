//
//  FollowListCell.swift
//  Photostream
//
//  Created by Mounir Ybanez on 17/01/2017.
//  Copyright © 2017 Mounir Ybanez. All rights reserved.
//

import UIKit

protocol FollowListCellDelegate: class {
    
    func didTapAction(cell: FollowListCell)
}

class FollowListCell: UITableViewCell {

    weak var delegate: FollowListCellDelegate?
    
    var actionButton: UIButton!
    var avatarImageView: UIImageView!
    var displayNameLabel: UILabel!
    
    convenience init() {
        self.init(style: .default, reuseIdentifier: FollowListCell.reuseId)
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
        actionButton = UIButton()
        actionButton.cornerRadius = 2
        actionButton.addTarget(self, action: #selector(self.didTapAction), for: .touchUpInside)
        actionButton.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
        actionButton.borderWidth = 1
        actionButton.setTitle("Action", for: .normal)
        actionButton.setTitleColor(UIColor(red: 10/255, green: 10/255, blue: 10/255, alpha: 1), for: .normal)
        actionButton.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightMedium)
        
        avatarImageView = UIImageView()
        avatarImageView.cornerRadius = avatarDimension / 2
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.backgroundColor = .lightGray
        
        displayNameLabel = UILabel()
        displayNameLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightMedium)
        
        addSubview(actionButton)
        addSubview(avatarImageView)
        addSubview(displayNameLabel)
    }
    
    override func layoutSubviews() {
        var rect = CGRect.zero
        
        rect.size.width = 80
        rect.size.height = 32
        rect.origin.y = (spacing * 2)
        rect.origin.x = frame.width
        rect.origin.x -= (spacing * 2)
        rect.origin.x -= rect.size.width
        actionButton.frame = rect
        
        rect.origin.x = (spacing * 2)
        rect.size.width = avatarDimension
        rect.size.height = avatarDimension
        avatarImageView.frame = rect
        
        rect.origin.x = rect.maxY
        rect.origin.x += spacing
        rect.size.width = frame.width
        rect.size.width -= rect.origin.x
        rect.size.width -= actionButton.frame.width
        rect.size.width -= (spacing * 3)
        displayNameLabel.frame = rect
    }
    
    func didTapAction() {
        delegate?.didTapAction(cell: self)
    }
}

extension FollowListCell {
    
    static var reuseId: String {
        return "FollowListCell"
    }
    
    var spacing: CGFloat {
        return 4
    }
    
    var avatarDimension: CGFloat {
        return 32
    }
}

extension FollowListCell {
    
    class func register(in tableView: UITableView) {
        tableView.register(self, forCellReuseIdentifier: FollowListCell.reuseId)
    }
    
    class func dequeue(from tableView: UITableView) -> FollowListCell? {
        let cell = tableView.dequeueReusableCell(withIdentifier: FollowListCell.reuseId)
        return cell as? FollowListCell
    }
}
