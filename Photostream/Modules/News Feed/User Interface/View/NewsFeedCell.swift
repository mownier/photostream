//
//  NewsFeedCell.swift
//  Photostream
//
//  Created by Mounir Ybanez on 17/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit
import Kingfisher
import Spring

let kNewsFeedCellNibName = "NewsFeedCell"
let kNewsFeedCellReuseId = "NewsFeedCell"
let kNewsFeedCellCommonHeight: CGFloat = 16.0
let kNewsFeedCellCommonTop: CGFloat = 12.0

protocol NewsFeedCellDelegate: class {

    func newsFeedCellDidTapLike(_ cell: NewsFeedCell)
    func newsFeedCellDidTapLikesCount(_ cell: NewsFeedCell)
    func newsFeedCellDidTapComment(_ cell: NewsFeedCell)
    func newsFeedCellDidTapCommentsCount(_ cell: NewsFeedCell)
    func newsFeedCellDidTapPhoto(_ cell: NewsFeedCell)
}

class NewsFeedCell: UICollectionViewCell {

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

    weak var delegate: NewsFeedCellDelegate!

    override func awakeFromNib() {
        super.awakeFromNib()

        photoImageView.isUserInteractionEnabled = true

        let tap = UITapGestureRecognizer(target: self, action: #selector(NewsFeedCell.didTapPhoto(_:)))
        tap.numberOfTapsRequired = 2
        photoImageView.addGestureRecognizer(tap)
    }

    @IBAction func didTapPhoto(_ sender: AnyObject) {
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
                self.delegate.newsFeedCellDidTapPhoto(self)
            })
        }
        shouldHighlightLikeButton(true)
        likeButton.animation = "pop"
        likeButton.duration = 1.0
        likeButton.animate()
    }

    @IBAction func didTapComment(_ sender: AnyObject) {
        delegate.newsFeedCellDidTapComment(self)
    }

    @IBAction func didTapLike(_ sender: AnyObject) {
        delegate.newsFeedCellDidTapLike(self)
    }

    @IBAction func didTapCommentsCount(_ sender: AnyObject) {
        delegate.newsFeedCellDidTapCommentsCount(self)
    }

    @IBAction func didTapLikesCount(_ sender: AnyObject) {
        delegate.newsFeedCellDidTapLikesCount(self)
    }

    func setPhotoUrl(_ url: String!) {
        let resource = ImageResource(downloadURL: URL(string: url)!)
        photoImageView.kf.setImage(with: resource)
    }

    func setLikesCountText(_ text: String) {
        if text.isEmpty {
            likesCountConstraintHeight.constant = 0
            heartIconConstraintHeight.constant = 0
            heartIconConstraintTop.constant = 0
        } else {
            likesCountButton.setTitle(text, for: UIControlState())

            heartIconConstraintTop.constant = kNewsFeedCellCommonTop
            heartIconConstraintHeight.constant = kNewsFeedCellCommonHeight
            likesCountConstraintHeight.constant = kNewsFeedCellCommonHeight
        }
    }

    func setCommentsCountText(_ text: String) {
        if text.isEmpty {
            commentsCountConstraintHeight.constant = 0
            commentsCountConstraintTop.constant = 0
        } else {
            commentsCountButton.setTitle(text, for: UIControlState())

            commentsCountConstraintTop.constant = kNewsFeedCellCommonTop
            commentsCountConstraintHeight.constant = kNewsFeedCellCommonHeight
        }
    }

    func setMessage(_ msg: String!, displayName: String!) {
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
            messageConstraintTop.constant = kNewsFeedCellCommonTop
        }
    }

    func setElapsedTime(_ time: String) {
        timeLabel.text = time
    }

    func shouldHighlightLikeButton(_ should: Bool) {
        if should {
            likeButton.setImage(UIImage(named: "heart_pink"), for: UIControlState())
        } else {
            likeButton.setImage(UIImage(named: "heart"), for: UIControlState())
        }
    }

    class func createNew() -> NewsFeedCell! {
        let bundle = Bundle.main
        let views = bundle.loadNibNamed(kNewsFeedCellNibName, owner: nil, options: nil)
        let cell = views?[0] as! NewsFeedCell
        return cell
    }

    class func dequeueFromCollectionView(_ view: UICollectionView, indexPath: IndexPath) -> NewsFeedCell {
        let cell = view.dequeueReusableCell(withReuseIdentifier: kNewsFeedCellReuseId, for: indexPath)
        return cell as! NewsFeedCell
    }

    class func registerNibInto(_ view: UICollectionView) {
        view.register(UINib(nibName: kNewsFeedCellNibName, bundle: nil), forCellWithReuseIdentifier: kNewsFeedCellReuseId)
    }
}
