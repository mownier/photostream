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

    func postGridCellWillShowPostDetails(_ index: Int)
}

open class PostGridCell: UICollectionViewCell {

    @IBOutlet fileprivate weak var photoImageView: UIImageView!

    open func setPhotoUrl(_ url: String, placeholderImage: UIImage?) {
        let resource = ImageResource(downloadURL: URL(string: url)!)
        photoImageView.kf.setImage(with: resource, placeholder: placeholderImage, options: nil, progressBlock: nil, completionHandler: nil)
    }
}
