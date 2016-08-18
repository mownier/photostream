//
//  NewsFeedCell.swift
//  Photostream
//
//  Created by Mounir Ybanez on 17/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit
import Kingfisher

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
    
    func setLikesCount(count: Int) {
        if count < 1 {
            likesCountConstraintHeight.constant = CGFloat(0.0)
            heartIconConstraintHeight.constant = CGFloat(0.0)
        } else {
            var likes = "likes"
            if count == 1 {
                likes = "like"
            }
            likes = "\(count) \(likes)"
            likesCountButton.setTitle(likes, forState: .Normal)
        }
    }
}
