//
//  NewsFeedModuleInterface.swift
//  Photostream
//
//  Created by Mounir Ybanez on 17/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

protocol NewsFeedModuleInterface: class {

    func refreshFeed(_ limit: UInt!)
    func retrieveNextFeed(_ limit: UInt!)

    func presentCommentsInterface(_ shouldComment: Bool)

    func toggleLike(_ postId: String, isLiked: Bool)
    func likePost(_ postId: String)
    func unlikePost(_ postId: String)
}
