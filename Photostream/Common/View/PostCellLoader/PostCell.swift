//
//  PostCell.swift
//  Photostream
//
//  Created by Mounir Ybanez on 25/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit
import Spring
import Kingfisher

let kPostCellNibName = "PostCell"
let kPostCellReuseId = "PostCell"
let kPostCellCommonHeight: CGFloat = 16.0
let kPostCellCommonTop: CGFloat = 12.0
let kPostCellInitialHeight: CGFloat = 287.0
let kPostCellInitialPhotoHeight: CGFloat = 115.0

public protocol PostCellActionHandler {
    
    func postCellDidTapComment(cell: PostCell)
    func postCellDidTapLike(cell: PostCell)
    func postCellDidTapLikesCount(cell: PostCell)
    func postCellDidTapCommentsCount(cell: PostCell)
    func postCellDidTapPhoto(cell: PostCell)
}

public class PostCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var likeButton: SpringButton!
    @IBOutlet weak var likesCountButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var commentsCountButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var likesCountConstraintHeight: NSLayoutConstraint!
    @IBOutlet weak var heartIconConstraintHeight: NSLayoutConstraint!
    @IBOutlet weak var commentsCountConstraintHeight: NSLayoutConstraint!
    
    @IBOutlet weak var commentsCountConstraintTop: NSLayoutConstraint!
    @IBOutlet weak var heartIconConstraintTop: NSLayoutConstraint!
    @IBOutlet weak var messageConstraintTop: NSLayoutConstraint!
    
    public var actionHandler: PostCellActionHandler!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        addPhotoTap()
    }
    
    @IBAction func didTapComment() {
        actionHandler.postCellDidTapComment(self)
    }
    
    @IBAction func didTapLike() {
        actionHandler.postCellDidTapLike(self)
    }
    
    @IBAction func didTapLikesCount() {
        actionHandler.postCellDidTapLikesCount(self)
    }
    
    @IBAction func didTapCommentsCount() {
        actionHandler.postCellDidTapCommentsCount(self)
    }
    
    @IBAction func didTapPhoto() {
        showAnimatedHeart({})
        shouldHighlightLikeButton(true)
        animateLikeButton()
        actionHandler.postCellDidTapPhoto(self)
    }
    
    public func setPhotoUrl(url: String!) {
        photoImageView.kf_setImageWithURL(NSURL(string: url))
    }
    
    public func setLikesCountText(text: String) {
        if text.isEmpty {
            likesCountConstraintHeight.constant = 0
            heartIconConstraintHeight.constant = 0
            heartIconConstraintTop.constant = 0
        } else {
            likesCountButton.setTitle(text, forState: .Normal)
            
            heartIconConstraintTop.constant = kPostCellCommonTop
            heartIconConstraintHeight.constant = kPostCellCommonHeight
            likesCountConstraintHeight.constant = kPostCellCommonHeight
        }
    }
    
    public func setCommentsCountText(text: String) {
        if text.isEmpty {
            commentsCountConstraintHeight.constant = 0
            commentsCountConstraintTop.constant = 0
        } else {
            commentsCountButton.setTitle(text, forState: .Normal)
            
            commentsCountConstraintTop.constant = kPostCellCommonTop
            commentsCountConstraintHeight.constant = kPostCellCommonHeight
        }
    }
    
    public func setMessage(msg: String!, displayName: String!) {
        if msg.isEmpty {
            messageLabel.attributedText = NSAttributedString(string: "")
            messageConstraintTop.constant = 0
        } else {
            let text = formatMessageText(msg, displayName: displayName)
            messageLabel.attributedText = text
            messageConstraintTop.constant = kPostCellCommonTop
        }
    }
    
    public func setElapsedTime(time: String) {
        timeLabel.text = time
    }
    
    public func shouldHighlightLikeButton(should: Bool) {
        if should {
            likeButton.setImage(UIImage(named: "heart_pink"), forState: .Normal)
        } else {
            likeButton.setImage(UIImage(named: "heart"), forState: .Normal)
        }
    }
    
    private func addPhotoTap() {
        photoImageView.userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(PostCell.didTapPhoto))
        tap.numberOfTapsRequired = 2
        photoImageView.addGestureRecognizer(tap)
    }
    
    private func showAnimatedHeart(completion: () -> Void) {
        let heart = SpringImageView(image: UIImage(named: "heart_pink"))
        heart.frame = CGRectMake(0, 0, 48, 48)
        photoImageView.addSubviewAtCenter(heart)
        heart.autohide = true
        heart.autostart = false
        heart.animation = "pop"
        heart.duration = 1.0
        heart.animateToNext {
            heart.animation = "fadeOut"
            heart.duration = 0.5
            heart.animateToNext({
                heart.removeFromSuperview()
                completion()
            })
        }
    }
    
    private func animateLikeButton() {
        likeButton.animation = "pop"
        likeButton.duration = 1.0
        likeButton.animate()
    }
    
    private func formatMessageText(msg: String, displayName: String!) -> NSAttributedString {
        let semiBold = UIFont.systemFontOfSize(14.0, weight: UIFontWeightSemibold)
        let regular = UIFont.systemFontOfSize(14.0)
        let name = NSAttributedString(string: displayName, attributes: [NSFontAttributeName: semiBold])
        let message = NSAttributedString(string: msg, attributes: [NSFontAttributeName: regular])
        let text = NSMutableAttributedString()
        text.appendAttributedString(name)
        text.appendAttributedString(NSAttributedString(string: " "))
        text.appendAttributedString(message)
        return text
    }
}
