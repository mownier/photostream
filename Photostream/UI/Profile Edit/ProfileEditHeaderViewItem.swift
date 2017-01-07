//
//  ProfileEditHeaderViewItem.swift
//  Photostream
//
//  Created by Mounir Ybanez on 07/01/2017.
//  Copyright © 2017 Mounir Ybanez. All rights reserved.
//

import Kingfisher

protocol ProfileEditHeaderViewItem {
    
    var displayNameInitial: String { get }
    var avatarUrl: String { set get }
}

protocol ProfileEditHeaderViewConfig {
    
    func configure(with item: ProfileEditHeaderViewItem?, isPrototype: Bool)
    func setupAvatar(url: String, placeholder image: UIImage?)
}

extension ProfileEditHeaderView: ProfileEditHeaderViewConfig {
    
    func configure(with item: ProfileEditHeaderViewItem?, isPrototype: Bool = false) {
        guard let item = item else {
            return
        }
        
        if !isPrototype {
            let image = placeholder(with: item.displayNameInitial)
            setupAvatar(url: item.avatarUrl, placeholder: image)
        }
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
    
    fileprivate func placeholder(with initial: String) -> UIImage {
        let frame = CGRect(x: 0, y: 0, width: avatarDimension, height: avatarDimension)
        let font = UIFont.systemFont(ofSize: avatarDimension / 2)
        let image = UILabel.createPlaceholderImageWithFrame(frame, text: initial, font: font)
        return image
    }
}
