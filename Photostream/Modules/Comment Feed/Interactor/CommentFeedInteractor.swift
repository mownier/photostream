//
//  CommenFeedInteractor.swift
//  Photostream
//
//  Created by Mounir Ybanez on 28/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

class CommentFeedInteractor: CommentFeedInteractorInterface {

    typealias Output = CommentFeedInteractorOutput
    
    weak var output: Output?
    
    var service: CommentService!
    
    required init(service: CommentService) {
        self.service = service
    }
}

extension CommentFeedInteractor: CommentFeedInteractorInput {
    
    func fetchComments(with postId: String) {
        service.fetchComments(postId: postId, offset: 0, limit: 10) { (result) in
            guard result.error == nil else {
                self.output?.commentFeedDidFetch(with: result.error!)
                return
            }

            guard let list = result.comments, list.comments.count > 0  else {
                self.output?.commentFeedDidFetch(with: [CommentFeedDataItem]())
                return
            }
            
            var feed = [CommentFeedDataItem]()
            
            for (_, comment) in list.comments.enumerated() {
                guard let user = list.users[comment.userId] else {
                    continue
                }
                
                var item = CommentFeedDataItem()
                item.id = comment.id
                item.content = comment.message
                item.timestamp = comment.timestamp
                item.authorId = user.id
                item.authorName = user.displayName
                item.authorAvatar = user.avatarUrl
                
                feed.append(item)
            }
            
            self.output?.commentFeedDidFetch(with: feed)
        }
    }
}
