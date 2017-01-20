//
//  PostLikeViewDataSource.swift
//  Photostream
//
//  Created by Mounir Ybanez on 20/01/2017.
//  Copyright © 2017 Mounir Ybanez. All rights reserved.
//

import UIKit

extension PostLikeViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.likeCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UserTableCell.dequeue(from: tableView)!
        let item = presenter.like(at: indexPath.row) as? UserTableCellItem
        cell.configure(item: item)
        cell.delegate = self
        return cell
    }
}
