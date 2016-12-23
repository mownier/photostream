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
}
