//
//  CommenFeedInteractor.swift
//  Photostream
//
//  Created by Mounir Ybanez on 28/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

class CommenFeedInteractor: CommentFeedInteractorInterface {

    typealias Output = CommentFeedInteractorOutput
    
    weak var output: Output?
    
    var service: CommentService!
    
    required init(service: CommentService) {
        self.service = service
    }
}

extension CommenFeedInteractor: CommentFeedInteractorInput {
    
    func fetchComments(with postId: String) {
        service.fetchComments(postId: postId, offset: 0, limit: 10) { (result) in
            guard result.error == nil else {
                self.output?.commentFeedDidFetch(with: result.error!)
                return
            }
            
            self.output?.commentFeedDidFetch(with: result.comments!)
        }
    }
}
