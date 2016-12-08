//
//  PostListCollectionCell.swift
//  Photostream
//
//  Created by Mounir Ybanez on 07/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class PostListCollectionCell: UICollectionViewCell {

    var photoImageView: UIImageView!
    var heartButton: UIButton!
    var commentButton: UIButton!
    var stripView: UIView!
    var likeCountLabel: UILabel!
    var messageLabel: UILabel!
    var commentCountLabel: UILabel!
    var timeLabel: UILabel!

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSetup()
    }
    
    func initSetup() {
        photoImageView = UIImageView()
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.clipsToBounds = true
        photoImageView.backgroundColor = UIColor.lightGray
        
        heartButton = UIButton()
        heartButton.addTarget(self, action: #selector(self.didTapHeart), for: .touchUpInside)
        heartButton.setImage(#imageLiteral(resourceName: "heart"), for: .normal)
        
        commentButton = UIButton()
        commentButton.addTarget(self, action: #selector(self.didTapComment), for: .touchUpInside)
        commentButton.setImage(#imageLiteral(resourceName: "comment"), for: .normal)
        
        stripView = UIView()
        stripView.backgroundColor = UIColor.lightGray
        
        likeCountLabel = UILabel()
        likeCountLabel.numberOfLines = 0
        
        messageLabel = UILabel()
        messageLabel.numberOfLines = 0
        
        commentCountLabel = UILabel()
        commentCountLabel.numberOfLines = 0
        
        timeLabel = UILabel()
        timeLabel.numberOfLines = 0
        
        contentView.addSubview(photoImageView)
        contentView.addSubview(heartButton)
        contentView.addSubview(commentButton)
        contentView.addSubview(stripView)
        contentView.addSubview(likeCountLabel)
        contentView.addSubview(messageLabel)
        contentView.addSubview(commentCountLabel)
        contentView.addSubview(timeLabel)
    }
    
    override func layoutSubviews() {
        var rect = photoImageView.frame
        
        let ratio = contentView.bounds.width / rect.size.width
        rect.size.width = contentView.bounds.width
        rect.size.height = rect.size.height * ratio
        photoImageView.frame = rect
        
        rect.origin.x = spacing * 2
        rect.origin.y = rect.size.height + (spacing * 2)
        rect.size = heartButton.sizeThatFits(.zero)
        heartButton.frame = rect
        
        rect.origin.x += rect.size.width + (spacing * 2)
        rect.size = commentButton.sizeThatFits(.zero)
        commentButton.frame = rect
        
        rect.origin.x = spacing * 2
        rect.origin.y += max(heartButton.frame.size.height, commentButton.frame.size.height)
        rect.origin.y += (spacing * 2)
        rect.size.height = 1
        rect.size.width = contentView.bounds.width - (spacing * 4)
        stripView.frame = rect
        
        if let text = messageLabel.text, !text.isEmpty {
            rect.origin.y += (spacing * 2) + rect.size.height
            rect.size.height = messageLabel.sizeThatFits(rect.size).height
            messageLabel.frame = rect
            
        } else {
            messageLabel.frame = .zero
        }

        if let text = commentCountLabel.text, !text.isEmpty {
            rect.origin.y += (spacing * 2) + rect.size.height
            rect.size.height = commentCountLabel.sizeThatFits(rect.size).height
            commentCountLabel.frame = rect
            
        } else {
            commentCountLabel.frame = .zero
        }
        
        rect.origin.y += (spacing * 2) + rect.size.height
        rect.size.height = timeLabel.sizeThatFits(rect.size).height
        timeLabel.frame = rect
    }
}

extension PostListCollectionCell {
    
    func didTapHeart() {
        
    }
    
    func didTapComment() {
        
    }
}

extension PostListCollectionCell {
    
    var spacing: CGFloat {
        return 4
    }
}

extension PostListCollectionCell {
    
    static var reuseId: String {
        return "PostListColllectionCell"
    }
    
    class func register(in view: UICollectionView) {
        view.register(self, forCellWithReuseIdentifier: self.reuseId)
    }
    
    class func dequeue(from view: UICollectionView, for indexPath: IndexPath) -> PostListCollectionCell? {
        let cell = view.dequeueReusableCell(withReuseIdentifier: self.reuseId, for: indexPath)
        return cell as? PostListCollectionCell
    }
}

