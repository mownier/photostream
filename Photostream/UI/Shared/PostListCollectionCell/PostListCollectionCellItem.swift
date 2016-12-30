//
//  PostListCollectionCellItem.swift
//  Photostream
//
//  Created by Mounir Ybanez on 08/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Kingfisher

protocol PostListCollectionCellItem {
    
    var message: String { get }
    var displayName: String { get }
    var avatarUrl: String { get }
    var photoUrl: String { get }
    var photoSize: CGSize { get }
    var timeAgo: String { get }
    var isLiked: Bool { get }
    var likesText: String { get }
    var commentsText: String { get }
}

protocol PostListCollectionCellConfig {
    
    var dynamicHeight: CGFloat { get }
    
    func configure(with item: PostListCollectionCellItem?, isPrototype: Bool)
    func set(message: String, displayName: String)
    func set(photo url: String)
    func set(liked: Bool)
}

extension PostListCollectionCell: PostListCollectionCellConfig {
    
    var dynamicHeight: CGFloat {
        var height = timeLabel.frame.origin.y
        height += timeLabel.frame.size.height
        height += (spacing * 2)
        return height
    }
    
    func configure(with item: PostListCollectionCellItem?, isPrototype: Bool = false) {
        guard let item = item else {
            return
        }
        
        if !isPrototype {
            set(photo: item.photoUrl)
        }
        
        set(message: item.message, displayName: item.displayName)
        set(liked: item.isLiked)
        
        timeLabel.text = item.timeAgo.uppercased()
        likeCountLabel.text = item.likesText
        commentCountLabel.text = item.commentsText
        photoImageView.frame.size = item.photoSize
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    func set(message: String, displayName: String) {
        guard !message.isEmpty else {
            messageLabel.attributedText = NSAttributedString(string: "")
            return
        }
        
        let font = messageLabel.font!
        let semiBold = UIFont.systemFont(ofSize: font.pointSize, weight: UIFontWeightSemibold)
        let regular = UIFont.systemFont(ofSize: font.pointSize)
        let name = NSAttributedString(string: displayName, attributes: [NSFontAttributeName: semiBold])
        let message = NSAttributedString(string: message, attributes: [NSFontAttributeName: regular])
        let text = NSMutableAttributedString()
        text.append(name)
        text.append(NSAttributedString(string: " "))
        text.append(message)
        messageLabel.attributedText = text
    }
    
    func set(photo url: String) {
        guard let downloadUrl = URL(string: url) else {
            return
        }
        
        let resource = ImageResource(downloadURL: downloadUrl)
        photoImageView.backgroundColor = UIColor.lightGray
        photoImageView.kf.setImage(
            with: resource,
            placeholder: nil,
            options: nil,
            progressBlock: nil) { [weak self] (_, _, _, _) in
            self?.photoImageView.backgroundColor = UIColor.white
        }
    }
    
    func set(liked: Bool) {
        if liked {
            heartButton.setImage(UIImage(named: "heart_pink"), for: .normal)
        } else {
            heartButton.setImage(UIImage(named: "heart"), for: .normal)
        }
    }
}
