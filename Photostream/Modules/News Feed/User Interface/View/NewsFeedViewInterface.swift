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
    func showItems(_ items: PostCellItemArray)
    func showError(_ error: NSError)
    func updateCell(_ postId: String, isLiked: Bool)
}
