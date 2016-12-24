//
//  ActivityTableLikeCell.swift
//  Photostream
//
//  Created by Mounir Ybanez on 23/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class ActivityTableLikeCell: UITableViewCell {
    
}

extension ActivityTableLikeCell {
    
    static var reuseId: String {
        return "ActivityTableLikeCell"
    }
}

extension ActivityTableLikeCell {
    
    class func dequeue(from view: UITableView) -> ActivityTableLikeCell? {
        return view.dequeueReusableCell(withIdentifier: ActivityTableLikeCell.reuseId) as? ActivityTableLikeCell
    }
    
    class func register(in view: UITableView) {
        view.register(ActivityTableLikeCell.self, forCellReuseIdentifier: ActivityTableLikeCell.reuseId)
    }
}

