//
//  NewsFeedItemParser.swift
//  Photostream
//
//  Created by Mounir Ybanez on 03/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

protocol NewsFeedItem {}

protocol NewsFeedItemAd: NewsFeedItem {}

protocol NewsFeedItemPost: NewsFeedItem {}

protocol NewsFeedItemParser {
    
    func parse(with post: NewsFeedPost) -> NewsFeedItem
    func parse(with ad: NewsFeedAd) -> NewsFeedItem
    func parse(with data: NewsFeedData) -> NewsFeedItemList
}

struct NewsFeedItemList {
    
    var items = [NewsFeedItem]()
    
}
