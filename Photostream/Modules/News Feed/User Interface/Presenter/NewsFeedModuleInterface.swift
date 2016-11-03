//
//  NewsFeedModuleInterface.swift
//  Photostream
//
//  Created by Mounir Ybanez on 03/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

protocol NewsFeedModuleInterface: class {

    func refreshFeeds()
    func loadMoreFeeds()
    
    func like(post id: String)
    func unlike(post id: String)
    
    var feedCount: Int { get }
    func feed(at index: Int) -> NewsFeedDataItem?
}
