//
//  NewsFeedInteractor.swift
//  Photostream
//
//  Created by Mounir Ybanez on 06/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

class NewsFeedInteractor: NewsFeedInteractorInput {

    var output: NewsFeedInteractorOutput!
    var service: PostService!
    
    init(service: PostService!) {
        self.service = service
    }
    
    func fetch(offset: UInt = 0, limit: UInt = 10) {
        service.get(offset, limit: limit) { (posts, error) in
            if let error = error {
                self.output.newsFeedDidFetchWithError(error)
            } else {
                self.output.newsFeedDidFetch(posts)
            }
        }
    }
}
