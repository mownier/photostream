//
//  NewsFeedCell.swift
//  Photostream
//
//  Created by Mounir Ybanez on 17/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit
import Kingfisher
import DateTools

enum NewsFeedCellConstants: CGFloat {
    case CommonHeight = 16.0
    case CommonTop = 12.0
}

protocol NewsFeedCellDelegate: class {

    func newsFeedCellDidTapLike(cell: NewsFeedCell)
    func newsFeedCellDidTapLikesCount(cell: NewsFeedCell)
    func newsFeedCellDidTapComment(cell: NewsFeedCell)
    func newsFeedCellDidTapCommentsCount(cell: NewsFeedCell)
}

class NewsFeedCell: UICollectionViewCell {

    private let COMMON_HEIGHT: CGFloat = 16.0
    private let COMMON_TOP: CGFloat = 12.0

    @IBOutlet weak var commentsCountButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var likesCountButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!

    @IBOutlet weak var likesCountConstraintHeight: NSLayoutConstraint!
    @IBOutlet weak var heartIconConstraintHeight: NSLayoutConstraint!
    @IBOutlet weak var commentsCountConstraintHeight: NSLayoutConstraint!

    @IBOutlet weak var commentsCountConstraintTop: NSLayoutConstraint!
    @IBOutlet weak var heartIconConstraintTop: NSLayoutConstraint!
    @IBOutlet weak var messageConstraintTop: NSLayoutConstraint!

    weak var delegate: NewsFeedCellDelegate!

    @IBAction func didTapComment(sender: AnyObject) {
        delegate.newsFeedCellDidTapComment(self)
    }

    @IBAction func didTapLike(sender: AnyObject) {
        delegate.newsFeedCellDidTapLike(self)
    }

    @IBAction func didTapCommentsCount(sender: AnyObject) {
        delegate.newsFeedCellDidTapCommentsCount(self)
    }

    @IBAction func didTapLikesCount(sender: AnyObject) {
        delegate.newsFeedCellDidTapLikesCount(self)
    }

    func setPhotoUrl(url: String!) {
        photoImageView.kf_setImageWithURL(NSURL(string: url))
    }

    func setLikesCount(count: Int64) {
        if count < 1 {
            likesCountConstraintHeight.constant = 0
            heartIconConstraintHeight.constant = 0
            heartIconConstraintTop.constant = 0
        } else {
            var likes = "likes"
            if count == 1 {
                likes = "like"
            }
            likes = "\(count) \(likes)"
            likesCountButton.setTitle(likes, forState: .Normal)

            heartIconConstraintTop.constant = COMMON_TOP
            heartIconConstraintHeight.constant = COMMON_HEIGHT
            likesCountConstraintHeight.constant = COMMON_HEIGHT
        }
    }

    func setCommentsCount(count: Int64) {
        if count < 1 {
            commentsCountConstraintHeight.constant = 0
            commentsCountConstraintTop.constant = 0
        } else {
            var comments = ""
            if count > 4 {
                comments = "View all \(count) comments"
            } else {
                if count == 1 {
                    comments = "View \(count) comment"
                } else {
                    comments = "View \(count) comments"
                }
            }
            commentsCountButton.setTitle(comments, forState: .Normal)

            commentsCountConstraintTop.constant = COMMON_TOP
            commentsCountConstraintHeight.constant = COMMON_HEIGHT
        }
    }

    func setMessage(msg: String!, displayName: String!) {
        if msg.isEmpty {
            messageLabel.attributedText = NSAttributedString(string: "")
            messageConstraintTop.constant = 0
        } else {
            let semiBold = UIFont.systemFontOfSize(14.0, weight: UIFontWeightSemibold)
            let regular = UIFont.systemFontOfSize(14.0)
            let name = NSAttributedString(string: displayName, attributes: [NSFontAttributeName: semiBold])
            let message = NSAttributedString(string: msg, attributes: [NSFontAttributeName: regular])
            let text = NSMutableAttributedString()
            text.appendAttributedString(name)
            text.appendAttributedString(NSAttributedString(string: " "))
            text.appendAttributedString(message)
            messageLabel.attributedText = text
            messageConstraintTop.constant = COMMON_TOP
        }
    }

    func setElapsedTime(timestamp: Double!) {
        let time = NSDate(timeIntervalSince1970: timestamp / 1000)
        timeLabel.text = time.timeAgoSinceNow().uppercaseString
    }

    class func createNew() -> NewsFeedCell! {
        let bundle = NSBundle.mainBundle()
        let views = bundle.loadNibNamed("NewsFeedCell", owner: nil, options: nil)
        let cell = views[0] as! NewsFeedCell
        return cell
    }
}
