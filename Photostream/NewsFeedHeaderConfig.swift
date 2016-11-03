//
//  NewsFeedHeaderConfig.swift
//  Photostream
//
//  Created by Mounir Ybanez on 03/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

extension PostListHeader {

    func configure(for post: NewsFeedPost) {
        let placeholder = createAvatarPlaceholderImage(with: post.displayName[0])
        displayName = post.displayName
        setAvatar(with: post.avatarUrl, and: placeholder)
    }
}
