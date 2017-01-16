//
//  ProfileEditViewDataSource.swift
//  Photostream
//
//  Created by Mounir Ybanez on 09/01/2017.
//  Copyright © 2017 Mounir Ybanez. All rights reserved.
//

import UIKit

extension ProfileEditViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.displayItemCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let style = cellStyle(for: indexPath.row)
        let cell = ProfileEditTableCell.dequeue(from: tableView, style: style)!
        let item = presenter.displayItem(at: indexPath.row) as? ProfileEditTableCellItem
        cell.configure(with: item)
        cell.infoTextField?.delegate = self
        cell.selectionStyle = .none
        return cell
    }
    
    func cellStyle(for index: Int) -> ProfileEditTableCellStyle {
        if let item = presenter.displayItem(at: index), item.isEditable {
            return .lineEdit
            
        } else {
            return .default
        }
    }
}

