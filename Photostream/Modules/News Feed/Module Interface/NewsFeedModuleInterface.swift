//
//  NewsFeedModuleInterface.swift
//  Photostream
//
//  Created by Mounir Ybanez on 17/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

protocol NewsFeedModuleInterface: class {
    
    var feedCount: Int! { get }
    
    func refreshFeed(limit: UInt!)
    func retrieveNextFeed(limit: UInt!)
    
    func getPostAtIndex(index: UInt!) -> (Post!, User!)
}
