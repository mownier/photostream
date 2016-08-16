//
//  NewsFeedHeaderView.swift
//  Photostream
//
//  Created by Mounir Ybanez on 16/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit
import Kingfisher

class NewsFeedHeaderView: UICollectionReusableView {

    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var displayNameLabel: UILabel!

    func setDisplayName(name: String) {
        displayNameLabel.text = name
    }

    func setAvatarUrl(url: String) {
        avatarImageView.kf_setImageWithURL(NSURL(string: url))
    }
}
