//
//  NewsFeedInteractorInput.swift
//  Photostream
//
//  Created by Mounir Ybanez on 06/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

protocol NewsFeedInteractorInput {
    
    mutating func fetchNew(limit: UInt)
    mutating func fetchNext(limit: UInt)
    func likePost(id: String)
    func unlikePost(id: String)
}
