//
//  FollowListModuleExtension.swift
//  Photostream
//
//  Created by Mounir Ybanez on 17/01/2017.
//  Copyright © 2017 Mounir Ybanez. All rights reserved.
//

import UIKit

extension FollowListModule {
    
    convenience init() {
        self.init(view: FollowListViewController())
    }
}

extension FollowListDataItem: FollowListCellItem { }
