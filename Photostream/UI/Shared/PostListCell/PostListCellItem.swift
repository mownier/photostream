//
//  PostListCellItem.swift
//  Photostream
//
//  Created by Mounir Ybanez on 03/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

protocol PostListCellItem {
    
    var message: String { get }
    var displayName: String { get }
    var avatarUrl: String { get }
    var photoUrl: String { get }
    var timeAgo: String { get }
    var isLiked: Bool { get }
    var likesText: String { get }
    var commentsText: String { get }
}
