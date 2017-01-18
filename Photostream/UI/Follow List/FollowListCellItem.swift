//
//  FollowListCellItem.swift
//  Photostream
//
//  Created by Mounir Ybanez on 17/01/2017.
//  Copyright © 2017 Mounir Ybanez. All rights reserved.
//

import Kingfisher

protocol FollowListCellItem {

    var isMe: Bool { get }
    var isFollowing: Bool { get }
    var avatarUrl: String { get }
    var displayName: String { get }
}

protocol FollowListCellConfig {
    
    func configure(item: FollowListCellItem?, isPrototype: Bool)
    func setupAvatar(url: String, placeholder image: UIImage?)
    func setupActionButton(isFollowing: Bool, isMe: Bool)
    func setupDisplayNameLabel(text: String)
}

extension FollowListCell: FollowListCellConfig {
    
    func configure(item: FollowListCellItem?, isPrototype: Bool = false) {
        guard let item = item else {
            return
        }
        
        setupDisplayNameLabel(text: item.displayName)
        setupActionButton(isFollowing: item.isFollowing, isMe: item.isMe)
        
        if !isPrototype {
            let image = placeholder(with: item.displayName[0])
            setupAvatar(url: item.avatarUrl, placeholder: image)
        }
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    func setupDisplayNameLabel(text: String) {
        displayNameLabel.text = text
    }
    
    func setupAvatar(url: String, placeholder image: UIImage?) {
        guard let downloadUrl = URL(string: url) else {
            avatarImageView.image = image
            return
        }
        
        let resource = ImageResource(downloadURL: downloadUrl)
        avatarImageView.kf.setImage(
            with: resource,
            placeholder: image,
            options: nil,
            progressBlock: nil,
            completionHandler: nil)
    }
    
    func setupActionButton(isFollowing: Bool, isMe: Bool) {
        guard !isMe else {
            actionButton.isHidden = true
            return
        }
        
        actionButton.isHidden = false
        
        var title: String!
        var titleColor: UIColor!
        var backgroundColor: UIColor!
        var borderColor: UIColor!
        
        if isFollowing {
            title = "Following"
            titleColor = UIColor.white
            backgroundColor = UIColor(red: 42/255, green: 163/255, blue: 239/255, alpha: 1)
            borderColor = backgroundColor
            
        } else {
            title = "Follow"
            titleColor = UIColor(red: 10/255, green: 10/255, blue: 10/255, alpha: 1)
            backgroundColor = UIColor.white
            borderColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1)
        }
        
        actionButton.setTitle(title, for: .normal)
        actionButton.setTitleColor(titleColor, for: .normal)
        actionButton.backgroundColor = backgroundColor
        actionButton.borderColor = borderColor
    }
    
    fileprivate func placeholder(with initial: String) -> UIImage {
        let frame = CGRect(x: 0, y: 0, width: avatarDimension, height: avatarDimension)
        let font = UIFont.systemFont(ofSize: avatarDimension / 2)
        let image = UILabel.createPlaceholderImageWithFrame(frame, text: initial, font: font)
        return image
    }
}
