//
//  PostListCollectionHeader.swift
//  Photostream
//
//  Created by Mounir Ybanez on 08/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

protocol PostListCollectionHeaderDelegate: class {
    
    func didTapDisplayName(header: PostListCollectionHeader, point: CGPoint)
    func didTapAvatar(header: PostListCollectionHeader, point: CGPoint)
}

class PostListCollectionHeader: UICollectionReusableView {
    
    weak var delegate: PostListCollectionHeaderDelegate?
    
    var avatarImageView: UIImageView!
    var displayNameLabel: UILabel!
    var stripView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSetup()
    }
    
    func initSetup() {
        backgroundColor = UIColor.white
        
        avatarImageView = UIImageView()
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.backgroundColor = UIColor.lightGray
        avatarImageView.cornerRadius = avatarDimension / 2
        avatarImageView.isUserInteractionEnabled = true
        
        displayNameLabel = UILabel()
        displayNameLabel.textColor = UIColor(red: 10/255, green: 10/255, blue: 10/255, alpha: 1)
        displayNameLabel.font = UIFont.boldSystemFont(ofSize: 12)
        displayNameLabel.isUserInteractionEnabled = true
        
        stripView = UIView()
        stripView.backgroundColor = UIColor(red: 223/255, green: 223/255, blue: 223/255, alpha: 1)
        
        var tap = UITapGestureRecognizer(target: self, action: #selector(self.didTapDisplayName(_:)))
        tap.numberOfTapsRequired = 1
        displayNameLabel.addGestureRecognizer(tap)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(self.didTapAvatar(_:)))
        tap.numberOfTapsRequired = 1
        avatarImageView.addGestureRecognizer(tap)
        
        addSubview(avatarImageView)
        addSubview(displayNameLabel)
        addSubview(stripView)
    }
    
    override func layoutSubviews() {
        var rect = CGRect.zero
        
        rect.origin.x = spacing * 2
        rect.origin.y = (frame.size.height - avatarDimension) / 2
        rect.size.width = avatarDimension
        rect.size.height = avatarDimension
        avatarImageView.frame = rect
        
        rect.origin.x += spacing
        rect.origin.x += rect.size.width
        rect.size.width = frame.size.width
        rect.size.width -= rect.origin.x
        rect.size.width -= (spacing * 2)
        rect.size.height = displayNameLabel.sizeThatFits(.zero).height
        rect.origin.y = (frame.size.height - rect.size.height) / 2
        displayNameLabel.frame = rect
        
        rect.origin.x = 0
        rect.origin.y = frame.size.height - 1
        rect.size.width = frame.size.width
        rect.size.height = 1
        stripView.frame = rect
    }
}

extension PostListCollectionHeader {
    
    func didTapDisplayName(_ tap: UITapGestureRecognizer) {
        let point = tap.location(in: self)
        delegate?.didTapDisplayName(header: self, point: point)
    }
    
    func didTapAvatar(_ tap: UITapGestureRecognizer) {
        let point = tap.location(in: self)
        delegate?.didTapAvatar(header: self, point: point)
    }
}

extension PostListCollectionHeader {
    
    var avatarDimension: CGFloat {
        return 28
    }
    
    var spacing: CGFloat {
        return 4
    }
}

extension PostListCollectionHeader {
    
    static var reuseId: String {
        return "PostListCollectionHeader"
    }
    
    class func register(in view: UICollectionView) {
        let kind = UICollectionElementKindSectionHeader
        view.register(self, forSupplementaryViewOfKind: kind, withReuseIdentifier: self.reuseId)
    }
    
    class func dequeue(from view: UICollectionView, for indexPath: IndexPath) -> PostListCollectionHeader?  {
        let kind = UICollectionElementKindSectionHeader
        let header = view.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.reuseId, for: indexPath)
        return header as? PostListCollectionHeader
    }
}
