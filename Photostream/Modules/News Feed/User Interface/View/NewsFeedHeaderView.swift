//
//  NewsFeedHeaderView.swift
//  Photostream
//
//  Created by Mounir Ybanez on 16/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit
import Kingfisher

let kNewsFeedHeaderViewReuseId = "NewsFeedHeaderView"
let kNewsFeedHeaderViewDefaultHeight: CGFloat = 54

class NewsFeedHeaderView: UICollectionReusableView {

    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var displayNameLabel: UILabel!

    func setDisplayName(name: String) {
        displayNameLabel.text = name
    }

    func setAvatarUrl(url: String, placeholderImage: UIImage) {
        avatarImageView.kf_setImageWithURL(NSURL(string: url), placeholderImage: placeholderImage, optionsInfo: nil, progressBlock: nil, completionHandler: nil)
    }

    func createAvatarPlaceholderImage(initial: String) -> UIImage {
        let width = avatarImageView.width
        let height = avatarImageView.height
        let frame = CGRectMake(0, 0, width, height)
        let font = UIFont.systemFontOfSize(15)
        let text: String = initial
        let placeholderImage = UILabel.createPlaceholderImageWithFrame(frame, text: text, font: font)
        return placeholderImage
    }

    class func dequeueFromCollectionView(view: UICollectionView, indexPath: NSIndexPath) -> NewsFeedHeaderView {
        let kind = UICollectionElementKindSectionHeader
        let headerView = view.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: kNewsFeedHeaderViewReuseId, forIndexPath: indexPath)
        return headerView as! NewsFeedHeaderView
    }
}
