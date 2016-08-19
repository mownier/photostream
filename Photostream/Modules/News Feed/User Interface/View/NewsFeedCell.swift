//
//  NewsFeedCell.swift
//  Photostream
//
//  Created by Mounir Ybanez on 17/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit
import Kingfisher

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

    @IBOutlet weak var commentsCountButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var likesCountButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var likesCountConstraintHeight: NSLayoutConstraint!
    @IBOutlet weak var heartIconConstraintHeight: NSLayoutConstraint!
    @IBOutlet weak var messageConstraintHeight: NSLayoutConstraint!
    @IBOutlet weak var commentsCountConstraintHeight: NSLayoutConstraint!
    
    @IBOutlet weak var commentsCountConstraintTop: NSLayoutConstraint!
    @IBOutlet weak var heartIconConstraintTop: NSLayoutConstraint!
    @IBOutlet weak var messageConstraintTop: NSLayoutConstraint!
    
    weak var delegate: NewsFeedCellDelegate!
    
    private let COMMON_HEIGHT: CGFloat = 16.0
    private let COMMON_TOP: CGFloat = 12.0
    
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
    
    class func expectedHeight(msg: String!, _ likesCount: Int64!, _ commentsCount: Int64!, _ maxWidth: CGFloat!, _ font: UIFont!) -> CGFloat {
        var height: CGFloat = 287 - 116
        
        var heartIconTop: CGFloat = 0
        var heartIconHeight: CGFloat = 0
        if likesCount < 1 {
            heartIconTop = 12
            heartIconHeight = 16
        }
        height -= heartIconTop - heartIconHeight
        
        var commentsCountTop: CGFloat = 0
        var commentsCountHeight: CGFloat = 0
        if commentsCount < 1 {
            commentsCountTop = 12
            commentsCountHeight = 16
        }
        height -= commentsCountTop - commentsCountHeight
        
        let preferredMaxLayoutWidth = maxWidth - 12 - 12
        let expectedMessageHeight: CGFloat = NewsFeedCell.expectedMessageHeight(msg, preferredMaxLayoutWidth, font)
        
        var messageTop: CGFloat = 0
        var messageHeight: CGFloat = 0
        if expectedMessageHeight < 1 {
            messageTop = 12
            messageHeight = 16
        } else {
            messageHeight = 16
        }
        height -= messageTop - messageHeight
        
        height += expectedMessageHeight
        
        return height
    }
    
    class func expectedMessageHeight(msg: String!, _ maxWidth: CGFloat, _ font: UIFont) -> CGFloat {
        if msg.isEmpty {
            return 0
        } else {
            let label = UILabel(frame: CGRectMake(0, 0, maxWidth, 16))
            label.numberOfLines = 0
            label.preferredMaxLayoutWidth = maxWidth
            label.font = font
            label.text = msg
            return label.intrinsicContentSize().height
        }
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
    
    func setMessage(msg: String!) {
        if msg.isEmpty {
            messageConstraintTop.constant = 0
            messageConstraintHeight.constant = 0
        } else {
            messageLabel.attributedText = NSAttributedString(string: msg)
            messageLabel.setNeedsDisplay()
            messageConstraintTop.constant = COMMON_TOP
            messageConstraintHeight.constant = messageLabel.intrinsicContentSize().height
            print(messageLabel.intrinsicContentSize())
        }
    }
}
