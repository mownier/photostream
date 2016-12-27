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
        
        switch item {
            
        case let likeItem as ActivityTableCellLikeItem:
            likeCellPrototype.configure(with: likeItem, isPrototype: true)
            return likeCellPrototype.dynamicHeight
        
        case let commentItem as ActivityTableCellCommentItem:
            commentCellPrototype.configure(with: commentItem, isPrototype: true)
            return commentCellPrototype.dynamicHeight
            
        default:
            return 44
        }
    }
}

extension UserActivityViewController: ActivityTableFollowCellDelegate {
    
    func didTapAction(cell: ActivityTableFollowCell) {
        
    }
}
