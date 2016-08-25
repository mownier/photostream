//
//  PostHeaderView.swift
//  Photostream
//
//  Created by Mounir Ybanez on 25/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

let kPostHeaderViewNibName = "PostHeaderView"
let kPostHeaderViewReuseId = "PostHeaderView"
let kPostHeaderViewHeight: CGFloat = 54

public class PostHeaderView: UICollectionReusableView {

    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var displayNameLabel: UILabel!
    
    public func setDisplayName(name: String) {
        displayNameLabel.text = name
    }
    
    public func setAvatarUrl(url: String, placeholderImage: UIImage) {
        avatarImageView.kf_setImageWithURL(NSURL(string: url), placeholderImage: placeholderImage, optionsInfo: nil, progressBlock: nil, completionHandler: nil)
    }
    
    public func createAvatarPlaceholderImage(initial: String) -> UIImage {
        let width = avatarImageView.width
        let height = avatarImageView.height
        let frame = CGRectMake(0, 0, width, height)
        let font = UIFont.systemFontOfSize(15)
        let text: String = initial
        let placeholderImage = UILabel.createPlaceholderImageWithFrame(frame, text: text, font: font)
        return placeholderImage
    }
}
