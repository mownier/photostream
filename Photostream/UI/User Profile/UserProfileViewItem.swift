//
//  UserProfileViewItem.swift
//  Photostream
//
//  Created by Mounir Ybanez on 10/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Kingfisher

protocol UserProfileViewItem {
    
    var avatarUrl: String { get }
    var postCountText: String { get }
    var followerCountText: String { get }
    var followingCountText: String { get }
    var displayName: String { get }
    var bio: String { get }
    var isMe: Bool { get }
    var isFollowed: Bool { get }
}

protocol UserProfileViewConfig {
    
    var dynamicHeight: CGFloat { get }
    
    func configure(wiht item: UserProfileViewItem?, isProtoype: Bool)
    func setupAvatar(with url: String)
    func setupActionButton(me: Bool, followed: Bool)
}

fileprivate enum ActionType {
    case edit
    case follow
    case unfollow
}

extension UserProfileView: UserProfileViewConfig {
    
    var dynamicHeight: CGFloat {
        return bioLabel.frame.maxY + (spacing * 2)
    }
    
    func configure(wiht item: UserProfileViewItem?, isProtoype: Bool = false) {
        guard let item = item else {
            return
        }
        
        postCountLabel.text = item.postCountText
        followerCountLabel.text = item.followerCountText
        followingCountLabel.text = item.followingCountText
        displayNameLabel.text = item.displayName.isEmpty ? "Name" : item.displayName
        bioLabel.text = item.bio.isEmpty ? "Bio here..." : item.bio
        
        setupActionButton(me: item.isMe, followed: item.isFollowed)
        
        if !isProtoype {
            setupAvatar(with: item.avatarUrl)
        }
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    func setupAvatar(with url: String) {
        let placeholder = avatarImageView.image ?? userImage
        
        guard let downloadUrl = URL(string: url) else {
            avatarImageView.image = placeholder
            return
        }
        
        let resource = ImageResource(downloadURL: downloadUrl)
        avatarImageView.kf.setImage(
            with: resource,
            placeholder: placeholder,
            options: nil,
            progressBlock: nil,
            completionHandler: nil)
    }
    
    func setupActionButton(me: Bool, followed: Bool) {
        actionButton.isUserInteractionEnabled = true
        
        guard !me else {
            setupActionButton(for: .edit)
            return
        }
        
        if followed {
            setupActionButton(for: .unfollow)
            
        } else {
            setupActionButton(for: .follow)
            
        }
    }
    
    fileprivate var userImage: UIImage {
        let frame = CGRect(x: 0, y: 0, width: avatarDimension, height: avatarDimension)
        let font = UIFont.systemFont(ofSize: avatarDimension / 2)
        let text: String = displayNameLabel.text![0]
        let image = UILabel.createPlaceholderImageWithFrame(frame, text: text, font: font)
        return image
    }
    
    fileprivate func setupActionButton(for type: ActionType) {
        actionButton.removeTarget(self, action: #selector(didTapToEdit), for: .touchUpInside)
        actionButton.removeTarget(self, action: #selector(didTapToFollow), for: .touchUpInside)
        actionButton.removeTarget(self, action: #selector(didTapToUnfollow), for: .touchUpInside)
        
        var action: Selector!
        var title: String!
        
        switch type {
        case .edit:
            title = "Edit Profile"
            action = #selector(self.didTapToEdit)
            
        case .follow:
            title = "Follow"
            action = #selector(self.didTapToFollow)
            
        case .unfollow:
            title = "Following"
            action = #selector(self.didTapToUnfollow)
        }
        
        actionButton.setTitle(title, for: .normal)
        actionButton.addTarget(self, action: action, for: .touchUpInside)
    }
}

extension UserProfileView {
    
    func didTapToEdit() {
        delegate?.willEdit(view: self)
    }
    
    func didTapToFollow() {
        delegate?.willFollow(view: self)
    }
    
    func didTapToUnfollow() {
        delegate?.willUnfollow(view: self)
    }
}
