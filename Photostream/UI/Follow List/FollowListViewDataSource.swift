//
//  FollowListViewDataSource.swift
//  Photostream
//
//  Created by Mounir Ybanez on 17/01/2017.
//  Copyright © 2017 Mounir Ybanez. All rights reserved.
//

import UIKit

extension FollowListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.listCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UserTableCell.dequeue(from: tableView)!
        let item = presenter.listItem(at: indexPath.row) as? UserTableCellItem
        cell.configure(item: item)
        cell.delegate = self
        return cell
    }
}
