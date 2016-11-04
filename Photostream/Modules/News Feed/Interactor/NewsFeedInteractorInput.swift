//
//  NewsFeedInteractorInput.swift
//  Photostream
//
//  Created by Mounir Ybanez on 06/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

protocol NewsFeedInteractorInput: class {
    
    func fetchNew(with limit: UInt)
    func fetchNext(with limit: UInt)
    func like(post id: String)
    func unlike(post id: String)
}
