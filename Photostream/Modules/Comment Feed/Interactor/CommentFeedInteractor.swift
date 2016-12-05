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
    var offset: String?
    
    fileprivate var isFetching: Bool = false
    
    required init(service: CommentService) {
        self.service = service
    }
    
    fileprivate func fetchComments(with postId: String, and limit: UInt) {
        guard output != nil, offset != nil, !isFetching else {
            return
        }
        
        isFetching = true
        service.fetchComments(postId: postId, offset: offset!, limit: limit) { (result) in
            self.isFetching = false
            
            guard result.error == nil else {
                if self.offset!.isEmpty {
                    self.output?.commentFeedDidRefresh(with: result.error!)
                } else {
                    self.output?.commentFeedDidLoadMore(with: result.error!)
                }
                return
            }
            
            guard let list = result.comments, list.comments.count > 0  else {
                if self.offset!.isEmpty {
                    self.output?.commentFeedDidRefresh(with: [CommentFeedDataItem]())
                } else {
                    self.output?.commentFeedDidLoadMore(with: [CommentFeedDataItem]())
                }
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
            
            if self.offset!.isEmpty {
                self.output?.commentFeedDidRefresh(with: feed)
            } else {
                self.output?.commentFeedDidLoadMore(with: feed)
            }
            
            self.offset = result.nextOffset
        }
    }
}

extension CommentFeedInteractor: CommentFeedInteractorInput {
    
    func fetchNew(with postId: String, and limit: UInt) {
        offset = ""
        fetchComments(with: postId, and: limit)
    }
    
    func fetchNext(with postId: String, and limit: UInt) {
        fetchComments(with: postId, and: limit)
    }
}
