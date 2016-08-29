//
//  NewsFeedViewInterface.swift
//  Photostream
//
//  Created by Mounir Ybanez on 17/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

protocol NewsFeedViewInterface: class {

    func reloadView()
    func showEmptyView()
    func showItems(items: PostCellItemArray)
    func showError(error: NSError)
    func updateCell(postId: String, isLiked: Bool)
}
