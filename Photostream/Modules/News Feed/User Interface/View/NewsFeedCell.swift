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

    class var nibName: String {
        return "NewsFeedCell"
    }

    class var reuseId: String {
        return "NewsFeedCell"
    }

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

    func setLikesCountText(text: String) {
        if text.isEmpty {
            likesCountConstraintHeight.constant = 0
            heartIconConstraintHeight.constant = 0
            heartIconConstraintTop.constant = 0
        } else {
            likesCountButton.setTitle(text, forState: .Normal)

            heartIconConstraintTop.constant = COMMON_TOP
            heartIconConstraintHeight.constant = COMMON_HEIGHT
            likesCountConstraintHeight.constant = COMMON_HEIGHT
        }
    }

    func setCommentsCountText(text: String) {
        if text.isEmpty {
            commentsCountConstraintHeight.constant = 0
            commentsCountConstraintTop.constant = 0
        } else {
            commentsCountButton.setTitle(text, forState: .Normal)

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

    func setElapsedTime(time: String) {
        timeLabel.text = time
    }

    class func createNew() -> NewsFeedCell! {
        let bundle = NSBundle.mainBundle()
        let views = bundle.loadNibNamed(NewsFeedCell.nibName, owner: nil, options: nil)
        let cell = views[0] as! NewsFeedCell
        return cell
    }

    class func dequeueFromCollectionView(view: UICollectionView, indexPath: NSIndexPath) -> NewsFeedCell {
        let cell = view.dequeueReusableCellWithReuseIdentifier(NewsFeedCell.reuseId, forIndexPath: indexPath)
        return cell as! NewsFeedCell
    }

    class func registerNibInto(view: UICollectionView) {
        let nibName = NewsFeedCell.nibName
        let reuseId = NewsFeedCell.reuseId
        view.registerNib(UINib(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: reuseId)
    }
}
