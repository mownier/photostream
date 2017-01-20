//
//  PostLikeViewDelegate.swift
//  Photostream
//
//  Created by Mounir Ybanez on 20/01/2017.
//  Copyright © 2017 Mounir Ybanez. All rights reserved.
//

import UIKit

extension PostLikeViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row == presenter.likeCount - 10 else {
            return
        }
        
        presenter.loadMore()
    }
}

extension PostLikeViewController: UserTableCellDelegate {
    
    func didTapAction(cell: UserTableCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        presenter.toggleFollow(at: indexPath.row)
    }
    
    func didTapDisplayName(cell: UserTableCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        presenter.presentUserTimeline(for: indexPath.row)
    }
}
