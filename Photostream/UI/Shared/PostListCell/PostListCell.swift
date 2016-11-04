//
//  PostListCell.swift
//  Photostream
//
//  Created by Mounir Ybanez on 17/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit
import Kingfisher
import Spring

let kPostListCellNibName = "PostListCell"
let kPostListCellReuseId = "PostListCell"
let kPostListCellCommonHeight: CGFloat = 16.0
let kPostListCellCommonTop: CGFloat = 12.0
let kPostListCellInitialHeight: CGFloat = 287.0

protocol PostListCellDelegate: NSObjectProtocol {

    func postListCellDidTapLike(cell: PostListCell)
    func postListCellDidTapLikesCount(cell: PostListCell)
    func postListCollectionCellDidTapLikesCount(cell: PostListCell)
    func postListCellDidTapComment(cell: PostListCell)
    func postListCellDidTapCommentsCount(cell: PostListCell)
    func postListCellDidTapPhoto(cell: PostListCell)
}

class PostListCell: UICollectionViewCell {

    @IBOutlet weak var commentsCountButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var likesCountButton: UIButton!
    @IBOutlet weak var likeButton: SpringButton!

    @IBOutlet weak var likesCountConstraintHeight: NSLayoutConstraint!
    @IBOutlet weak var heartIconConstraintHeight: NSLayoutConstraint!
    @IBOutlet weak var commentsCountConstraintHeight: NSLayoutConstraint!

    @IBOutlet weak var commentsCountConstraintTop: NSLayoutConstraint!
    @IBOutlet weak var heartIconConstraintTop: NSLayoutConstraint!
    @IBOutlet weak var messageConstraintTop: NSLayoutConstraint!

    weak var delegate: PostListCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        photoImageView.isUserInteractionEnabled = true

        let tap = UITapGestureRecognizer(target: self, action: #selector(PostListCell.didTapPhoto))
        tap.numberOfTapsRequired = 2
        photoImageView.addGestureRecognizer(tap)
    }

    @IBAction func didTapPhoto() {
        let heart = SpringImageView(image: UIImage(named: "heart_pink"))
        heart.frame = CGRect(x: 0, y: 0, width: 48, height: 48)
        photoImageView.addSubviewAtCenter(heart)
        heart.autohide = true
        heart.autostart = false
        heart.animation = "pop"
        heart.duration = 1.0
        heart.animateToNext {
            heart.animation = "fadeOut"
            heart.duration = 0.5
            heart.animateToNext(completion: {
                heart.removeFromSuperview()
                self.delegate?.postListCellDidTapPhoto(cell: self)
            })
        }
        shouldHighlightLikeButton(true)
        likeButton.animation = "pop"
        likeButton.duration = 1.0
        likeButton.animate()
    }

    @IBAction func didTapComment() {
        delegate?.postListCellDidTapComment(cell: self)
    }

    @IBAction func didTapLike() {
        delegate?.postListCellDidTapLike(cell: self)
    }

    @IBAction func didTapCommentsCount() {
        delegate?.postListCellDidTapCommentsCount(cell: self)
    }

    @IBAction func didTapLikesCount() {
        delegate?.postListCellDidTapLikesCount(cell: self)
    }
}

extension PostListCell {
    
    var likesCountText: String? {
        set {
            guard let text = newValue, !text.isEmpty else {
                likesCountButton.setTitle("", for: UIControlState())
                likesCountConstraintHeight.constant = 0
                heartIconConstraintHeight.constant = 0
                heartIconConstraintTop.constant = 0
                
                return
            }
            
            likesCountButton.setTitle(text, for: UIControlState())
            heartIconConstraintTop.constant = kPostListCellCommonTop
            heartIconConstraintHeight.constant = kPostListCellCommonHeight
            likesCountConstraintHeight.constant = kPostListCellCommonHeight
        }
        get {
            return likesCountButton.titleLabel?.text
        }
    }
    
    var commentsCountText: String? {
        set {
            guard let text = newValue, !text.isEmpty else {
                commentsCountButton.setTitle("", for: UIControlState())
                commentsCountConstraintHeight.constant = 0
                commentsCountConstraintTop.constant = 0
                return
            }
            
            commentsCountButton.setTitle(text, for: UIControlState())
            commentsCountConstraintTop.constant = kPostListCellCommonTop
            commentsCountConstraintHeight.constant = kPostListCellCommonHeight
        }
        get {
            return commentsCountButton.titleLabel?.text
        }
    }
    
    var elapsedTime: String? {
        set {
            timeLabel.text = newValue
        }
        get {
            return timeLabel.text
        }
    }
    
    func setPhoto(with url: String) {
        let resource = ImageResource(downloadURL: URL(string: url)!)
        photoImageView.kf.setImage(with: resource)
    }
    
    func setMessage(with msg: String, and displayName: String) {
        if msg.isEmpty {
            messageLabel.attributedText = NSAttributedString(string: "")
            messageConstraintTop.constant = 0
        } else {
            let semiBold = UIFont.systemFont(ofSize: 14.0, weight: UIFontWeightSemibold)
            let regular = UIFont.systemFont(ofSize: 14.0)
            let name = NSAttributedString(string: displayName, attributes: [NSFontAttributeName: semiBold])
            let message = NSAttributedString(string: msg, attributes: [NSFontAttributeName: regular])
            let text = NSMutableAttributedString()
            text.append(name)
            text.append(NSAttributedString(string: " "))
            text.append(message)
            messageLabel.attributedText = text
            messageConstraintTop.constant = kPostListCellCommonTop
        }
    }
    
    func shouldHighlightLikeButton(_ should: Bool) {
        if should {
            likeButton.setImage(UIImage(named: "heart_pink"), for: UIControlState())
        } else {
            likeButton.setImage(UIImage(named: "heart"), for: UIControlState())
        }
    }
}

extension PostListCell {
    
    class func createNew() -> PostListCell {
        let bundle = Bundle.main
        let views = bundle.loadNibNamed(kPostListCellNibName, owner: nil, options: nil)
        let cell = views?[0] as! PostListCell
        return cell
    }
    
    class func dequeue(from view: UICollectionView, at indexPath: IndexPath) -> PostListCell? {
        let cell = view.dequeueReusableCell(withReuseIdentifier: kPostListCellReuseId, for: indexPath)
        return cell as? PostListCell
    }
    
    class func registerNib(in view: UICollectionView) {
        view.register(UINib(nibName: kPostListCellNibName, bundle: nil), forCellWithReuseIdentifier: kPostListCellReuseId)
    }
}
