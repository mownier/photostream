//
//  UserActivityViewDataSource.swift
//  Photostream
//
//  Created by Mounir Ybanez on 23/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

extension UserActivityViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.activityCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ActivityTableCell.dequeue(from: tableView)!
        let item = presenter.activity(at: indexPath.row)!
        
        switch item {
            
        case let likeItem as ActivityTableCellLikeItem:
            cell.configure(with: likeItem)
        
        case let postItem as ActivityTableCellPostItem:
            cell.configure(with: postItem)
        
        case let commentItem as ActivityTableCellCommentItem:
            cell.configure(with: commentItem)
        
        case let followItem as ActivityTableCellFollowItem:
            cell.configure(with: followItem)
        
        default:
            break
        }
        
        return cell
    }
}
