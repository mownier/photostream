//
//  PhotoGridCell.swift
//  Photostream
//
//  Created by Mounir Ybanez on 11/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

let kPhotoGridCellReuseId = "PhotoGridCell"

class PhotoGridCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var whiteView: UIView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        thumbnailImageView.image = nil
        isSelected = false
    }
    
    override var isSelected: Bool {
        didSet {
            whiteView.isHidden = !isSelected
        }
    }
}

extension PhotoGridCell {
    
    class func dequeue(from view: UICollectionView, for indexPath: IndexPath) -> PhotoGridCell {
        let cell = view.dequeueReusableCell(withReuseIdentifier: kPhotoGridCellReuseId, for: indexPath)
        return cell as! PhotoGridCell
    }
}
