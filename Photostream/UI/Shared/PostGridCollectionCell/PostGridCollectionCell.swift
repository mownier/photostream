//
//  PostGridCollectionCell.swift
//  Photostream
//
//  Created by Mounir Ybanez on 06/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class PostGridCollectionCell: UICollectionViewCell {
    
    var photoImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSetup()
    }
    
    func initSetup() {
        contentView.backgroundColor = UIColor.white
        
        photoImageView = UIImageView()
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.backgroundColor = UIColor.lightGray
        photoImageView.clipsToBounds = true
        
        contentView.addSubview(photoImageView)
    }
    
    override func layoutSubviews() {
        photoImageView.frame = contentView.bounds
    }
}

extension PostGridCollectionCell {
    
    static var reuseId: String {
        return "PostGridCollectionCell"
    }
    
    class func register(in view: UICollectionView) {
        view.register(self, forCellWithReuseIdentifier: self.reuseId)
    }
    
    class func dequeue(from view: UICollectionView, for indexPath: IndexPath) -> PostGridCollectionCell? {
        let cell = view.dequeueReusableCell(withReuseIdentifier: self.reuseId, for: indexPath)
        return cell as? PostGridCollectionCell
    }
}
