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
        displayNameLabel.text = item.displayName.isEmpty ? "Me" : item.displayName
        bioLabel.text = item.bio.isEmpty ? "Write your bio here..." : item.bio
        
        setupActionButton(me: item.isMe, followed: item.isFollowed)
        
        if !isProtoype {
            setupAvatar(with: item.avatarUrl)
        }
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    func setupAvatar(with url: String) {
        guard let downloadUrl = URL(string: url) else {
            avatarImageView.image = userImage
            return
        }
        
        let resource = ImageResource(downloadURL: downloadUrl)
        avatarImageView.kf.setImage(
            with: resource,
            placeholder:
            userImage,
            options: nil,
            progressBlock: nil,
            completionHandler: nil)
    }
    
    func setupActionButton(me: Bool, followed: Bool) {
        guard !me else {
            actionButton.setTitle("Edit Profile", for: .normal)
            return
        }
        
        if followed {
            actionButton.setTitle("Follow", for: .normal)
        } else {
            actionButton.setTitle("Unfollow", for: .normal)
        }
    }
    
    fileprivate var userImage: UIImage {
        let frame = CGRect(x: 0, y: 0, width: avatarDimension, height: avatarDimension)
        let font = UIFont.systemFont(ofSize: avatarDimension / 2)
        let text: String = displayNameLabel.text![0]
        let image = UILabel.createPlaceholderImageWithFrame(frame, text: text, font: font)
        return image
    }
}
