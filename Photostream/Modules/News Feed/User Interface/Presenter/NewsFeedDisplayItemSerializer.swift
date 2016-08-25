//
//  NewsFeedDisplayItemSerializer.swift
//  Photostream
//
//  Created by Mounir Ybanez on 22/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

protocol NewsFeedDisplayItemSerializer: class {

    func serialize(post: NewsFeedPostData, user: NewsFeedUserData) -> PostCellItem
    
    func serialize(data: NewsFeedDataCollection) -> PostCellItemList
}
