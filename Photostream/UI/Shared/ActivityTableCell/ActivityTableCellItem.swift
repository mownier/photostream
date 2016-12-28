//
//  ActivityTableCellItem.swift
//  Photostream
//
//  Created by Mounir Ybanez on 23/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Kingfisher
import DateTools

protocol ActivityTableCellItem {
    
    var displayName: String { set get }
    var avatarUrl: String { set get }
    var timestamp: Double { set get }
    var content: String { get }
    var timeAgo: String { get }
}

extension ActivityTableCellItem {
    
    var timeAgo: String {
        let date = NSDate(timeIntervalSince1970: timestamp)
        return date.shortTimeAgoSinceNow()
    }
}

protocol ActivityTableCellLikeItem: ActivityTableCellItem {
    
    var photoUrl: String { set get }
}

protocol ActivityTableCellPostItem: ActivityTableCellItem {
    
    var photoUrl: String { set get }
}

protocol ActivityTableCellCommentItem: ActivityTableCellItem {
    
    var photoUrl: String { set get }
    var message: String { set get }
}

protocol ActivityTableCellFollowItem: ActivityTableCellItem {
    
    var isFollowing: Bool { set get }
}

protocol ActivityTableCellConfig {
    
    var dynamicHeight: CGFloat { get }
}

protocol ActivityTableLikeCellConfig: ActivityTableCellConfig {
    
    func configure(with item: ActivityTableCellLikeItem?, isPrototype: Bool)
}

protocol ActivityTablePostCellConfig: ActivityTableCellConfig {
    
    func configure(with item: ActivityTableCellPostItem?, isPrototype: Bool)
}

protocol ActivityTableCommentCellConfig: ActivityTableCellConfig {
    
    func configure(with item: ActivityTableCellCommentItem?, isPrototype: Bool)
}

protocol ActivityTableFollowCellConfig: ActivityTableCellConfig {
 
    func configure(with item: ActivityTableCellFollowItem?, isPrototype: Bool)
}

extension ActivityTableCellConfig {
    
    func authorPlaceholder(with name: String, size: CGSize) -> UIImage {
        let frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let font = UIFont.systemFont(ofSize: 12)
        let image = UILabel.createPlaceholderImageWithFrame(frame, text: name[0], font: font)
        return image
    }
}

extension ActivityTableLikeCell: ActivityTableLikeCellConfig {
    
    var dynamicHeight: CGFloat {
        var height = max(contentLabel.frame.height + spacing * 2, 0)
        height = max(avatarImageView.frame.height + spacing * 2, height)
        height = max(photoImageView.frame.height + spacing * 2, height)
        return height
    }
    
    func configure(with item: ActivityTableCellLikeItem?, isPrototype: Bool = false) {
        guard let item = item else {
            return
        }
        
        setup(content: item.content, displayName: item.displayName, timeAgo: item.timeAgo)
        
        if !isPrototype {
            setup(photo: item.photoUrl)
            
            let image = authorPlaceholder(
                with: item.displayName,
                size: CGSize(width: avatarDimension, height: avatarDimension)
            )
            setup(avatar: item.avatarUrl, placeholder: image)
        }
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    func setup(content: String, displayName: String, timeAgo: String) {
        let contentMessage = content.replaceFirstOccurrence(of: displayName, to: "").trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        let font = contentLabel.font!
        
        let semiBold = UIFont.systemFont(ofSize: font.pointSize, weight: UIFontWeightSemibold)
        let regular = UIFont.systemFont(ofSize: font.pointSize)
        
        let name = NSAttributedString(string: displayName, attributes: [NSFontAttributeName: semiBold])
        let message = NSAttributedString(string: contentMessage, attributes: [NSFontAttributeName: regular])
        let time = NSAttributedString(string: timeAgo, attributes: [NSFontAttributeName: regular, NSForegroundColorAttributeName: UIColor.lightGray])
        
        let text = NSMutableAttributedString()
        text.append(name)
        text.append(NSAttributedString(string: " "))
        text.append(message)
        text.append(NSAttributedString(string: " "))
        text.append(time)
        
        contentLabel.attributedText = text
    }
    
    func setup(photo url: String) {
        guard let downloadUrl = URL(string: url) else {
            return
        }
        
        let resource = ImageResource(downloadURL: downloadUrl)
        photoImageView.kf.setImage(with: resource)
    }
    
    func setup(avatar url: String, placeholder image: UIImage?) {
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
}

extension ActivityTableCommentCell: ActivityTableCommentCellConfig {
    
    var dynamicHeight: CGFloat {
        var height = max(contentLabel.frame.height + spacing * 2, 0)
        height = max(avatarImageView.frame.height + spacing * 2, height)
        height = max(photoImageView.frame.height + spacing * 2, height)
        return height
    }
    
    func configure(with item: ActivityTableCellCommentItem?, isPrototype: Bool = false) {
        guard let item = item else {
            return
        }
        
        setup(content: item.content, displayName: item.displayName, timeAgo: item.timeAgo)
        
        if !isPrototype {
            setup(photo: item.photoUrl)
            
            let image = authorPlaceholder(
                with: item.displayName,
                size: CGSize(width: avatarDimension, height: avatarDimension)
            )
            setup(avatar: item.avatarUrl, placeholder: image)
        }
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    func setup(content: String, displayName: String, timeAgo: String) {
        let contentMessage = content.replaceFirstOccurrence(of: displayName, to: "").trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        let font = contentLabel.font!
        
        let semiBold = UIFont.systemFont(ofSize: font.pointSize, weight: UIFontWeightSemibold)
        let regular = UIFont.systemFont(ofSize: font.pointSize)
        
        let name = NSAttributedString(string: displayName, attributes: [NSFontAttributeName: semiBold])
        let message = NSAttributedString(string: contentMessage, attributes: [NSFontAttributeName: regular])
        let time = NSAttributedString(string: timeAgo, attributes: [NSFontAttributeName: regular, NSForegroundColorAttributeName: UIColor.lightGray])
        
        let text = NSMutableAttributedString()
        text.append(name)
        text.append(NSAttributedString(string: " "))
        text.append(message)
        text.append(NSAttributedString(string: " "))
        text.append(time)
        
        contentLabel.attributedText = text
    }
    
    func setup(photo url: String) {
        guard let downloadUrl = URL(string: url) else {
            return
        }
        
        let resource = ImageResource(downloadURL: downloadUrl)
        photoImageView.kf.setImage(with: resource)
    }
    
    func setup(avatar url: String, placeholder image: UIImage?) {
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
}

extension ActivityTableFollowCell: ActivityTableFollowCellConfig {
    
    var dynamicHeight: CGFloat {
        var height = max(contentLabel.frame.height + spacing * 2, 0)
        height = max(avatarImageView.frame.height + spacing * 2, height)
        height = max(actionButton.frame.height + spacing * 2, height)
        return height
    }
    
    func configure(with item: ActivityTableCellFollowItem?, isPrototype: Bool = false) {
        guard let item = item else {
            return
        }
        
        setup(content: item.content, displayName: item.displayName, timeAgo: item.timeAgo)
        setup(isFollowing: item.isFollowing)
        
        if !isPrototype {
            let image = authorPlaceholder(
                with: item.displayName,
                size: CGSize(width: avatarDimension, height: avatarDimension)
            )
            setup(avatar: item.avatarUrl, placeholder: image)
        }
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    func setup(content: String, displayName: String, timeAgo: String) {
        let contentMessage = content.replaceFirstOccurrence(of: displayName, to: "").trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        let font = contentLabel.font!
        
        let semiBold = UIFont.systemFont(ofSize: font.pointSize, weight: UIFontWeightSemibold)
        let regular = UIFont.systemFont(ofSize: font.pointSize)
        
        let name = NSAttributedString(string: displayName, attributes: [NSFontAttributeName: semiBold])
        let message = NSAttributedString(string: contentMessage, attributes: [NSFontAttributeName: regular])
        let time = NSAttributedString(string: timeAgo, attributes: [NSFontAttributeName: regular, NSForegroundColorAttributeName: UIColor.lightGray])
        
        let text = NSMutableAttributedString()
        text.append(name)
        text.append(NSAttributedString(string: " "))
        text.append(message)
        text.append(NSAttributedString(string: " "))
        text.append(time)
        
        contentLabel.attributedText = text
    }
    
    func setup(avatar url: String, placeholder image: UIImage?) {
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
    
    func setup(isFollowing: Bool) {
        if isFollowing {
            actionButton.backgroundColor = UIColor(red: 42/255, green: 163/255, blue: 239/255, alpha: 1)
            actionButton.setImage(#imageLiteral(resourceName: "activity_follow_action_button_white"), for: .normal)
            actionButton.borderWidth = 0
        
        } else {
            actionButton.backgroundColor = UIColor.white
            actionButton.setImage(#imageLiteral(resourceName: "activity_follow_action_button_black"), for: .normal)
            actionButton.borderWidth = 1
        }
        
    }
}

extension ActivityTablePostCell: ActivityTablePostCellConfig {
    
    var dynamicHeight: CGFloat {
        var height = max(contentLabel.frame.height + spacing * 2, 0)
        height = max(avatarImageView.frame.height + spacing * 2, height)
        height = max(photoImageView.frame.height + spacing * 2, height)
        return height
    }
    
    func configure(with item: ActivityTableCellPostItem?, isPrototype: Bool = false) {
        guard let item = item else {
            return
        }
        
        setup(content: item.content, displayName: item.displayName, timeAgo: item.timeAgo)
        
        if !isPrototype {
            setup(photo: item.photoUrl)
            
            let image = authorPlaceholder(
                with: item.displayName,
                size: CGSize(width: avatarDimension, height: avatarDimension)
            )
            setup(avatar: item.avatarUrl, placeholder: image)
        }
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    func setup(content: String, displayName: String, timeAgo: String) {
        let contentMessage = content.replaceFirstOccurrence(of: displayName, to: "").trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        let font = contentLabel.font!
        
        let semiBold = UIFont.systemFont(ofSize: font.pointSize, weight: UIFontWeightSemibold)
        let regular = UIFont.systemFont(ofSize: font.pointSize)
        
        let name = NSAttributedString(string: displayName, attributes: [NSFontAttributeName: semiBold])
        let message = NSAttributedString(string: contentMessage, attributes: [NSFontAttributeName: regular])
        let time = NSAttributedString(string: timeAgo, attributes: [NSFontAttributeName: regular, NSForegroundColorAttributeName: UIColor.lightGray])
        
        let text = NSMutableAttributedString()
        text.append(name)
        text.append(NSAttributedString(string: " "))
        text.append(message)
        text.append(NSAttributedString(string: " "))
        text.append(time)
        
        contentLabel.attributedText = text
    }
    
    func setup(photo url: String) {
        guard let downloadUrl = URL(string: url) else {
            return
        }
        
        let resource = ImageResource(downloadURL: downloadUrl)
        photoImageView.kf.setImage(with: resource)
    }
    
    func setup(avatar url: String, placeholder image: UIImage?) {
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
}
