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

    func postCellDidTapComment(_ cell: PostCell)
    func postCellDidTapLike(_ cell: PostCell)
    func postCellDidTapLikesCount(_ cell: PostCell)
    func postCellDidTapCommentsCount(_ cell: PostCell)
    func postCellDidTapPhoto(_ cell: PostCell)
}

open class PostCell: UICollectionViewCell {

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

    open var actionHandler: PostCellActionHandler!

    override open func awakeFromNib() {
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

    open func setPhotoUrl(_ url: String!) {
        let resource = ImageResource(downloadURL: URL(string: url)!)
        photoImageView.kf.setImage(with: resource)
    }

    open func setLikesCountText(_ text: String) {
        if text.isEmpty {
            likesCountConstraintHeight.constant = 0
            heartIconConstraintHeight.constant = 0
            heartIconConstraintTop.constant = 0
        } else {
            likesCountButton.setTitle(text, for: UIControlState())

            heartIconConstraintTop.constant = kPostCellCommonTop
            heartIconConstraintHeight.constant = kPostCellCommonHeight
            likesCountConstraintHeight.constant = kPostCellCommonHeight
        }
    }

    open func setCommentsCountText(_ text: String) {
        if text.isEmpty {
            commentsCountConstraintHeight.constant = 0
            commentsCountConstraintTop.constant = 0
        } else {
            commentsCountButton.setTitle(text, for: UIControlState())

            commentsCountConstraintTop.constant = kPostCellCommonTop
            commentsCountConstraintHeight.constant = kPostCellCommonHeight
        }
    }

    open func setMessage(_ msg: String!, displayName: String!) {
        if msg.isEmpty {
            messageLabel.attributedText = NSAttributedString(string: "")
            messageConstraintTop.constant = 0
        } else {
            let text = formatMessageText(msg, displayName: displayName)
            messageLabel.attributedText = text
            messageConstraintTop.constant = kPostCellCommonTop
        }
    }

    open func setElapsedTime(_ time: String) {
        timeLabel.text = time
    }

    open func shouldHighlightLikeButton(_ should: Bool) {
        if should {
            likeButton.setImage(UIImage(named: "heart_pink"), for: UIControlState())
        } else {
            likeButton.setImage(UIImage(named: "heart"), for: UIControlState())
        }
    }

    fileprivate func addPhotoTap() {
        photoImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(PostCell.didTapPhoto))
        tap.numberOfTapsRequired = 2
        photoImageView.addGestureRecognizer(tap)
    }

    fileprivate func showAnimatedHeart(_ completion: @escaping () -> Void) {
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
                completion()
            })
        }
    }

    fileprivate func animateLikeButton() {
        likeButton.animation = "pop"
        likeButton.duration = 1.0
        likeButton.animate()
    }

    fileprivate func formatMessageText(_ msg: String, displayName: String!) -> NSAttributedString {
        let semiBold = UIFont.systemFont(ofSize: 14.0, weight: UIFontWeightSemibold)
        let regular = UIFont.systemFont(ofSize: 14.0)
        let name = NSAttributedString(string: displayName, attributes: [NSFontAttributeName: semiBold])
        let message = NSAttributedString(string: msg, attributes: [NSFontAttributeName: regular])
        let text = NSMutableAttributedString()
        text.append(name)
        text.append(NSAttributedString(string: " "))
        text.append(message)
        return text
    }
}
