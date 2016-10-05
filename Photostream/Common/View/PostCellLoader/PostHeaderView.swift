//
//  PostHeaderView.swift
//  Photostream
//
//  Created by Mounir Ybanez on 25/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit
import Kingfisher

let kPostHeaderViewNibName = "PostHeaderView"
let kPostHeaderViewReuseId = "PostHeaderView"
let kPostHeaderViewHeight: CGFloat = 54

open class PostHeaderView: UICollectionReusableView {

    @IBOutlet fileprivate weak var avatarImageView: UIImageView!
    @IBOutlet fileprivate weak var displayNameLabel: UILabel!

    open func setDisplayName(_ name: String) {
        displayNameLabel.text = name
    }

    open func setAvatarUrl(_ url: String, placeholderImage: UIImage) {
        let resource = ImageResource(downloadURL: URL(string: url)!)
        avatarImageView.kf.setImage(with: resource, placeholder: placeholderImage)
    }

    open func createAvatarPlaceholderImage(_ initial: String) -> UIImage {
        let width = avatarImageView.width
        let height = avatarImageView.height
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        let font = UIFont.systemFont(ofSize: 15)
        let text: String = initial
        let placeholderImage = UILabel.createPlaceholderImageWithFrame(frame, text: text, font: font)
        return placeholderImage
    }
}
