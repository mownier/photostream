//
//  NewsFeedInteractorInput.swift
//  Photostream
//
//  Created by Mounir Ybanez on 06/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

protocol NewsFeedInteractorInput: class {

    var feedCount: Int! { get }

    func fetchNew(limit: UInt!)
    func fetchNext(limit: UInt!)
    func fetchPost(index: UInt!) -> (Post!, User!)
}
