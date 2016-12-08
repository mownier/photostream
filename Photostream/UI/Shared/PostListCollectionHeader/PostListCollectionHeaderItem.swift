//
//  PostListCollectionHeaderItem.swift
//  Photostream
//
//  Created by Mounir Ybanez on 08/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Kingfisher

protocol PostListCollectionHeaderItem {

    var avatarUrl: String { get }
    var displayName: String { get }
}

protocol PostListCollectionHeaderConfig {
    
    func configure(with item: PostListCollectionHeaderItem?, isPrototype: Bool)
    func set(avatar url: String, placeholder image: UIImage?)
}

extension PostListCollectionHeader: PostListCollectionHeaderConfig {
    
    func configure(with item: PostListCollectionHeaderItem?, isPrototype: Bool = false) {
        guard item != nil else {
            return
        }
        
        if !isPrototype {
            let image = createAvatarPlaceholderImage(with: item!.displayName[0])
            set(avatar: item!.avatarUrl, placeholder: image)
        }
        
        displayNameLabel.text = item!.displayName
    }
    
    func set(avatar url: String, placeholder image: UIImage? = nil) {
        guard let downloadUrl = URL(string: url) else {
            avatarImageView.image = image
            return
        }
        
        let resource = ImageResource(downloadURL: downloadUrl)
        avatarImageView.kf.setImage(with: resource, placeholder: image, options: nil, progressBlock: nil, completionHandler: nil)
    }
    
    private func createAvatarPlaceholderImage(with initial: String) -> UIImage {
        let width: CGFloat = avatarDimension
        let height: CGFloat = avatarDimension
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        let font = UIFont.systemFont(ofSize: 12)
        let text: String = initial
        let placeholderImage = UILabel.createPlaceholderImageWithFrame(frame, text: text, font: font)
        return placeholderImage
    }
}
