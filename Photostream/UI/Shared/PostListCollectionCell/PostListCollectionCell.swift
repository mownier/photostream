//
//  PostListCollectionCell.swift
//  Photostream
//
//  Created by Mounir Ybanez on 07/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Spring

protocol PostListCollectionCellDelegate: class {
    
    func didTapPhoto(cell: PostListCollectionCell)
    func didTapHeart(cell: PostListCollectionCell)
    func didTapComment(cell: PostListCollectionCell)
    func didTapCommentCount(cell: PostListCollectionCell)
    func didTapLikeCount(cell: PostListCollectionCell)
}

class PostListCollectionCell: UICollectionViewCell {

    weak var delegate: PostListCollectionCellDelegate?
    
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
        photoImageView.contentMode = .scaleAspectFit
        photoImageView.clipsToBounds = true
        photoImageView.backgroundColor = UIColor.white
        photoImageView.isUserInteractionEnabled = true
        
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
        likeCountLabel.isUserInteractionEnabled = true
        
        messageLabel = UILabel()
        messageLabel.numberOfLines = 0
        messageLabel.font = UIFont.systemFont(ofSize: 12)
        messageLabel.textColor = primaryColor
        
        commentCountLabel = UILabel()
        commentCountLabel.numberOfLines = 0
        commentCountLabel.font = UIFont.systemFont(ofSize: 12)
        commentCountLabel.textColor = secondaryColor
        commentCountLabel.isUserInteractionEnabled = true
        
        timeLabel = UILabel()
        timeLabel.numberOfLines = 0
        timeLabel.font = UIFont.systemFont(ofSize: 8)
        timeLabel.textColor = secondaryColor
        
        var tap = UITapGestureRecognizer(target: self, action: #selector(self.didTapPhoto))
        tap.numberOfTapsRequired = 2
        photoImageView.addGestureRecognizer(tap)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(self.didTapCommentCount))
        tap.numberOfTapsRequired = 1
        commentCountLabel.addGestureRecognizer(tap)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(self.didTapLikeCount))
        tap.numberOfTapsRequired = 1
        likeCountLabel.addGestureRecognizer(tap)
        
        addSubview(photoImageView)
        addSubview(heartButton)
        addSubview(commentButton)
        addSubview(stripView)
        addSubview(likeCountLabel)
        addSubview(messageLabel)
        addSubview(commentCountLabel)
        addSubview(timeLabel)
    }
    
    override func layoutSubviews() {
        var rect = photoImageView.frame
        
        let ratio = bounds.width / rect.size.width
        rect.size.width = bounds.width
        rect.size.height = min(rect.size.width, rect.size.height * ratio)
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
        rect.size.width = bounds.width - (spacing * 4)
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
        delegate?.didTapHeart(cell: self)
    }
    
    func didTapComment() {
        delegate?.didTapComment(cell: self)
    }
    
    func didTapPhoto() {
        animateHeartButton { }
        showAnimatedHeart {
            self.delegate?.didTapPhoto(cell: self)
        }
    }
    
    func didTapCommentCount() {
        delegate?.didTapCommentCount(cell: self)
    }
    
    func didTapLikeCount() {
        delegate?.didTapLikeCount(cell: self)
    }
}

extension PostListCollectionCell {
    
    func showAnimatedHeart(completion: @escaping () -> Void) {
        let heart = SpringImageView(image: #imageLiteral(resourceName: "heart_pink"))
        heart.frame = CGRect(x: 0, y: 0, width: 48, height: 48)
        photoImageView.addSubviewAtCenter(heart)
        heart.autohide = true
        heart.autostart = false
        heart.animation = "pop"
        heart.duration = 1.0
        heart.animateToNext {
            heart.animation = "fadeOut"
            heart.duration = 0.5
            heart.animateToNext {
                heart.removeFromSuperview()
                completion()
            }
        }
    }
    
    func animateHeartButton(completion: @escaping () -> Void) {
        heartButton.isHidden = true
        let heart = SpringImageView(image: #imageLiteral(resourceName: "heart_pink"))
        heart.frame = heartButton.frame
        addSubview(heart)
        
        heart.autohide = true
        heart.autostart = false
        heart.animation = "pop"
        heart.duration = 1.0
        heart.animateToNext { [weak self] in
            heart.removeFromSuperview()
            self?.heartButton.setImage(#imageLiteral(resourceName: "heart_pink"), for: .normal)
            self?.heartButton.isHidden = false
            completion()
        }
    }
}

extension PostListCollectionCell {
       
    func toggleHeart(liked: Bool, completion: @escaping() -> Void) {
        if liked {
            heartButton.setImage(#imageLiteral(resourceName: "heart"), for: .normal)
            completion()

        } else {
            animateHeartButton { }
            showAnimatedHeart {
                completion()
            }
        }
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

