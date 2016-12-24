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
        var cell: UITableViewCell!
        let item = presenter.activity(at: indexPath.row)!
        
        switch item {
            
        case let likeItem as ActivityTableCellLikeItem:
            let tableCell = ActivityTableLikeCell.dequeue(from: tableView)!
            tableCell.configure(with: likeItem)
            cell = tableCell
        
        default:
            break
        }
        
        return cell
    }
}
