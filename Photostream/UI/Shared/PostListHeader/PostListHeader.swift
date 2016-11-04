//
//  PostListHeader.swift
//  Photostream
//
//  Created by Mounir Ybanez on 16/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit
import Kingfisher

let kPostListHeaderNibName = "PostListHeader"
let kPostListHeaderReuseId = "PostListHeader"
let kPostListHeaderDefaultHeight: CGFloat = 54

class PostListHeader: UICollectionReusableView {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var displayNameLabel: UILabel!

    var displayName: String? {
        set {
            displayNameLabel.text = newValue
        }
        get {
            return displayNameLabel.text
        }
    }

    func setAvatar(with url: String, and placeholderImage: UIImage) {
        guard let avatarUrl = URL(string: url) else {
            avatarImageView.image = placeholderImage
            return
        }
        
        let resource = ImageResource(downloadURL: avatarUrl)
        avatarImageView.kf.setImage(with: resource, placeholder: placeholderImage)
    }

    func createAvatarPlaceholderImage(with initial: String) -> UIImage {
        let width: CGFloat = 34.0
        let height: CGFloat = 34.0
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        let font = UIFont.systemFont(ofSize: 15)
        let text: String = initial
        let placeholderImage = UILabel.createPlaceholderImageWithFrame(frame, text: text, font: font)
        return placeholderImage
    }
}

extension PostListHeader {
    
    func configure(for item: PostListHeaderItem) {
        let placeholder = createAvatarPlaceholderImage(with: item.displayName[0])
        displayName = item.displayName
        setAvatar(with: item.avatarUrl, and: placeholder)
    }
}

extension PostListHeader {
    
    class func createNew() -> PostListHeader {
        let bundle = Bundle.main
        let views = bundle.loadNibNamed(kPostListHeaderNibName, owner: nil, options: nil)
        let header = views?[0] as! PostListHeader
        return header
    }
    
    class func dequeue(from view: UICollectionView, at indexPath: IndexPath) -> PostListHeader? {
        let kind = UICollectionElementKindSectionHeader
        let headerView = view.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kPostListHeaderReuseId, for: indexPath)
        return headerView as? PostListHeader
    }
    
    class func registerNib(in view: UICollectionView) {
        let nib = UINib(nibName: kPostListHeaderNibName, bundle: nil)
        let kind = UICollectionElementKindSectionHeader
        view.register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: kPostListHeaderReuseId)
    }
}
