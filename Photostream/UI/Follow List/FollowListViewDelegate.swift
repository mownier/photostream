//
//  FollowListViewDelegate.swift
//  Photostream
//
//  Created by Mounir Ybanez on 17/01/2017.
//  Copyright © 2017 Mounir Ybanez. All rights reserved.
//

import UIKit

extension FollowListViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row == presenter.listCount - 10 else {
            return
        }
        
        presenter.loadMore()
    }
}

extension FollowListViewController: FollowListCellDelegate {
    
    func didTapAction(cell: FollowListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        presenter.toggleFollow(at: indexPath.row)
    }
    
    func didTapDisplayName(cell: FollowListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        presenter.presentUserTimeline(for: indexPath.row)
    }
}
