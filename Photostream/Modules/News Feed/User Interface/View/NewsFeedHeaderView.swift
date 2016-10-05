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

    @IBOutlet fileprivate weak var avatarImageView: UIImageView!
    @IBOutlet fileprivate weak var displayNameLabel: UILabel!

    func setDisplayName(_ name: String) {
        displayNameLabel.text = name
    }

    func setAvatarUrl(_ url: String, placeholderImage: UIImage) {
        let resource = ImageResource(downloadURL: URL(string: url)!)
        avatarImageView.kf.setImage(with: resource, placeholder: placeholderImage)
    }

    func createAvatarPlaceholderImage(_ initial: String) -> UIImage {
        let width = avatarImageView.width
        let height = avatarImageView.height
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        let font = UIFont.systemFont(ofSize: 15)
        let text: String = initial
        let placeholderImage = UILabel.createPlaceholderImageWithFrame(frame, text: text, font: font)
        return placeholderImage
    }

    class func dequeueFromCollectionView(_ view: UICollectionView, indexPath: IndexPath) -> NewsFeedHeaderView {
        let kind = UICollectionElementKindSectionHeader
        let headerView = view.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kNewsFeedHeaderViewReuseId, for: indexPath)
        return headerView as! NewsFeedHeaderView
    }
}
