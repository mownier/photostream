//
//  ActivityTableCell.swift
//  Photostream
//
//  Created by Mounir Ybanez on 23/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class ActivityTableCell: UITableViewCell {
    
}

extension ActivityTableCell {
    
    static var reuseId: String {
        return "ActivityTableCell"
    }
}

extension ActivityTableCell {
    
    class func dequeue(from view: UITableView) -> ActivityTableCell? {
        return view.dequeueReusableCell(withIdentifier: ActivityTableCell.reuseId) as? ActivityTableCell
    }
    
    class func register(in view: UITableView) {
        view.register(ActivityTableCell.self, forCellReuseIdentifier: ActivityTableCell.reuseId)
    }
}

