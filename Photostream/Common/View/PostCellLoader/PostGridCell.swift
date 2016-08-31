//
//  PostGridCell.swift
//  Photostream
//
//  Created by Mounir Ybanez on 29/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit
import Kingfisher

let kPostGridCellReuseId = "PostGridCell"
let kPostGridCellNibName = "PostGridCell"

public protocol PostGridCellActionHandler {

    func postGridCellWillShowPostDetails(index: Int)
}

public class PostGridCell: UICollectionViewCell {

    @IBOutlet private weak var photoImageView: UIImageView!

    public func setPhotoUrl(url: String, placeholderImage: UIImage?) {
        photoImageView.kf_setImageWithURL(NSURL(string: url), placeholderImage: placeholderImage, optionsInfo: nil, progressBlock: nil, completionHandler: nil)
    }
}
