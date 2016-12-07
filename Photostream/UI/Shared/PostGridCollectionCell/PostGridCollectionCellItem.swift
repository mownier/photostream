//
//  PostGridCollectionCellItem.swift
//  Photostream
//
//  Created by Mounir Ybanez on 07/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Kingfisher

protocol PostGridCollectionCellItem {

    var photoUrl: String { get }
}

protocol PostGridCollectionCellConfig {
    
    func configure(with item: PostGridCollectionCellItem?, isPrototype: Bool)
    func set(photo url: String, placeholder image: UIImage?)
}

extension PostGridCollectionCell: PostGridCollectionCellConfig {
    
    func configure(with item: PostGridCollectionCellItem?, isPrototype: Bool = false) {
        guard item != nil, !isPrototype else {
            return
        }

        set(photo: item!.photoUrl, placeholder: nil)
    }
    
    func set(photo url: String, placeholder image: UIImage?) {
        guard let downloadUrl = URL(string: url) else {
            return
        }
        
        let resource = ImageResource(downloadURL: downloadUrl)
        photoImageView.kf.setImage(with: resource, placeholder: image, options: nil, progressBlock: nil, completionHandler: nil)
    }
}
