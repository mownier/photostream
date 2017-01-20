//
//  UserTableCell.swift
//  Photostream
//
//  Created by Mounir Ybanez on 20/01/2017.
//  Copyright © 2017 Mounir Ybanez. All rights reserved.
//

import UIKit

protocol UserTableCellDelegate: class {
    
    func didTapAction(cell: UserTableCell)
    func didTapDisplayName(cell: UserTableCell)
}

class UserTableCell: UITableViewCell {
    
    weak var delegate: UserTableCellDelegate?
    
    var actionButton: UIButton!
    var avatarImageView: UIImageView!
    var displayNameLabel: UILabel!
    var actionLoadingView: UIActivityIndicatorView!
    
    convenience init() {
        self.init(style: .default, reuseIdentifier: UserTableCell.reuseId)
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
        
        actionLoadingView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        actionLoadingView.hidesWhenStopped = true
        actionLoadingView.cornerRadius = actionButton.cornerRadius
        actionLoadingView.borderWidth = actionButton.borderWidth
        actionLoadingView.borderColor = actionButton.borderColor
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTapDisplayNameLabel))
        tap.numberOfTapsRequired = 1
        displayNameLabel.addGestureRecognizer(tap)
        displayNameLabel.isUserInteractionEnabled = true
        
        addSubview(actionButton)
        addSubview(avatarImageView)
        addSubview(displayNameLabel)
        addSubview(actionLoadingView)
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
        actionLoadingView.frame = rect
        
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
    
    func didTapDisplayNameLabel() {
        delegate?.didTapDisplayName(cell: self)
    }
}

extension UserTableCell {
    
    static var reuseId: String {
        return "UserTableCell"
    }
    
    var spacing: CGFloat {
        return 4
    }
    
    var avatarDimension: CGFloat {
        return 32
    }
}

extension UserTableCell {
    
    class func register(in tableView: UITableView) {
        tableView.register(self, forCellReuseIdentifier: UserTableCell.reuseId)
    }
    
    class func dequeue(from tableView: UITableView) -> UserTableCell? {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserTableCell.reuseId)
        return cell as? UserTableCell
    }
}
