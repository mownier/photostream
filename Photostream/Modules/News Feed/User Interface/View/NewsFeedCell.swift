//
//  NewsFeedCell.swift
//  Photostream
//
//  Created by Mounir Ybanez on 17/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit
import Kingfisher

class NewsFeedCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    func setPhotoUrl(url: String!) {
        photoImageView.kf_setImageWithURL(NSURL(string: url))
    }
}
