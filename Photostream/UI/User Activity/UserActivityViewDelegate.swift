//
//  UserActivityViewDelegate.swift
//  Photostream
//
//  Created by Mounir Ybanez on 23/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

extension UserActivityViewController {
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == presenter.activityCount - 10 {
            presenter.loadMoreActivities()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = presenter.activity(at: indexPath.row)!
        var height: CGFloat = 8
        
        switch item {
            
        case let likeItem as ActivityTableCellLikeItem:
            likeCellPrototype.configure(with: likeItem, isPrototype: true)
            height += likeCellPrototype.dynamicHeight
        
        case let commentItem as ActivityTableCellCommentItem:
            commentCellPrototype.configure(with: commentItem, isPrototype: true)
            height += commentCellPrototype.dynamicHeight
        
        case let followItem as ActivityTableCellFollowItem:
            followCellPrototype.configure(with: followItem, isPrototype: true)
            height += followCellPrototype.dynamicHeight
        
        case let postItem as ActivityTableCellPostItem:
            postCellPrototype.configure(with: postItem, isPrototype: true)
            height += postCellPrototype.dynamicHeight
            
        default:
            height += 44
        }
        
        return height
    }
}

extension UserActivityViewController: ActivityTableFollowCellDelegate, ActivityTableLikeCellDelegate, ActivityTableCommentCellDelegate, ActivityTablePostCellDelegate {
    
    func didTapAction(cell: ActivityTableFollowCell) {
        // TODO: Follow / Unfollow
    }
    
    func didTapPhoto(cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        presenter.presentSinglePost(for: indexPath.row)
    }
    
    func didTapAvatar(cell: UITableViewCell) {
        guard let index = tableView.indexPath(for: cell)?.row else {
            return
        }
        
        presenter.presentUserTimeline(at: index)
    }
}
