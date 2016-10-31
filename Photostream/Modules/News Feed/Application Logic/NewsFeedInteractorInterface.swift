//
//  NewsFeedInteractorInterface.swift
//  Photostream
//
//  Created by Mounir Ybanez on 29/10/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

protocol NewsFeedInteractorInterface {
    
    var offset: Offset { set get }
    var output: NewsFeedInteractorOutput? { set get }
    var service: NewsFeedService! { set get }
    
    init(service: NewsFeedService)
    
    associatedtype Offset
}
