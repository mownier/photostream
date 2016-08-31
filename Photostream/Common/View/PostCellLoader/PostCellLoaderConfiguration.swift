//
//  PostCellLoaderConfiguration.swift
//  Photostream
//
//  Created by Mounir Ybanez on 29/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

public protocol PostCellConfiguration {

    func configureHeaderView(view: PostHeaderView, item: PostCellItem)
    func configureCell(cell: PostCell, item: PostCellItem)
}

public protocol PostGridCellConfiguration {

    func configureCell(cell: PostGridCell, item: PostGridCellItem)
}
