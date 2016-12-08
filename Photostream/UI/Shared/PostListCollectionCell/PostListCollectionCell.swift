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
        stripView.backgroundColor = UIColor(red: 223/255, green: 223/255, blue: 223/255, alpha: 1)
        
        likeCountLabel = UILabel()
        likeCountLabel.numberOfLines = 0
        likeCountLabel.font = UIFont.boldSystemFont(ofSize: 12)
        likeCountLabel.textColor = primaryColor
        
        messageLabel = UILabel()
        messageLabel.numberOfLines = 0
        messageLabel.font = UIFont.systemFont(ofSize: 12)
        messageLabel.textColor = primaryColor
        
        commentCountLabel = UILabel()
        commentCountLabel.numberOfLines = 0
        commentCountLabel.font = UIFont.systemFont(ofSize: 12)
        commentCountLabel.textColor = secondaryColor
        
        timeLabel = UILabel()
        timeLabel.numberOfLines = 0
        timeLabel.font = UIFont.systemFont(ofSize: 8)
        timeLabel.textColor = secondaryColor
        
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
        rect.size = CGSize(width: buttonDimension, height: buttonDimension)
        heartButton.frame = rect
        
        rect.origin.x += rect.size.width + (spacing * 4)
        commentButton.frame = rect
        
        rect.origin.x = spacing * 2
        rect.origin.y += (spacing * 2)
        rect.origin.y += rect.size.height
        rect.size.height = 1
        rect.size.width = contentView.bounds.width - (spacing * 4)
        stripView.frame = rect
        
        if let text = likeCountLabel.text, !text.isEmpty {
            rect.origin.y += (spacing * 2) + rect.size.height
            rect.size.height = likeCountLabel.sizeThatFits(rect.size).height
            likeCountLabel.frame = rect
            
        } else {
            likeCountLabel.frame = .zero
        }
        
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
    
    var buttonDimension: CGFloat {
        return 24
    }
    
    var secondaryColor: UIColor {
        return UIColor(red: 157/255, green: 157/255, blue: 157/255, alpha: 1)
    }
    
    var primaryColor: UIColor {
        return UIColor(red: 10/255, green: 10/255, blue: 10/255, alpha: 1)
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

