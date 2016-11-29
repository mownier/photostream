//
//  CommentListCellItem.swift
//  Photostream
//
//  Created by Mounir Ybanez on 29/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Kingfisher

protocol CommentListCellItem {

    var authorName: String { get }
    var authorAvatar: String { get }
    var timeAgo: String { get }
    var content: String { get }
}

protocol CommentListCellConfig {
    
    func configure(with item: CommentListCellItem?, isPrototype: Bool)
    func set(photo url: String, placeholder image: UIImage)
    func set(author name: String)
    func set(content: String)
    func set(time: String)
}

extension CommentListCell: CommentListCellConfig {
    
    fileprivate var authorImage: UIImage {
        let frame = CGRect(x: 0, y: 0, width: photoLength, height: photoLength)
        let font = UIFont.systemFont(ofSize: 15)
        let text: String = authorLabel.text![0]
        let image = UILabel.createPlaceholderImageWithFrame(frame, text: text, font: font)
        return image
    }
    
    func configure(with item: CommentListCellItem?, isPrototype: Bool = false) {
        guard item != nil else {
            return
        }
        
        set(author: item!.authorName)
        set(content: item!.content)
        set(time: item!.timeAgo)
        
        if !isPrototype {
            set(photo: item!.authorAvatar, placeholder: authorImage)
        }
    }
    
    func set(photo url: String, placeholder image: UIImage) {
        guard let photoUrl = URL(string: url) else {
            authorPhoto.image = image
            return
        }
        
        let resource = ImageResource(downloadURL: photoUrl)
        authorPhoto.kf.setImage(with: resource, placeholder: image, options: nil, progressBlock: nil, completionHandler: nil)
    }
    
    func set(author name: String) {
        authorLabel.text = name
    }
    
    func set(content: String) {
        contentLabel.text = content
    }
    
    func set(time: String) {
        timeLabel.text = time
    }
}
