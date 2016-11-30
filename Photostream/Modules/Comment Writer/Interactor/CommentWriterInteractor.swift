//
//  CommentWriterInteractor.swift
//  Photostream
//
//  Created by Mounir Ybanez on 30/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

protocol CommentWriterInteractorInput: BaseModuleInteractorInput {
    
    func write(with postId: String, and content: String)
}

protocol CommentWriterInteractorOutput: BaseModuleInteractorOutput {
    
    func interactorDidFinish(with comment: CommentWriterData)
    func interactorDidFinish(with error: CommentServiceError)
}

protocol CommentWriterInteractorInterface: BaseModuleInteractor {

    var service: CommentService! { set get }
    
    init(service: CommentService)
}

class CommentWriterInteractor: CommentWriterInteractorInterface {
    
    typealias Output = CommentWriterInteractorOutput
    
    weak var output: Output?
    
    var service: CommentService!
    
    required init(service: CommentService) {
        self.service = service
    }
}

extension CommentWriterInteractor: CommentWriterInteractorInput {
    
    func write(with postId: String, and content: String) {
        service.writeComment(postId: postId, message: content) { (result) in
            guard result.error == nil else {
                self.output?.interactorDidFinish(with: result.error!)
                return
            }
            
            guard let list = result.comments, list.comments.count > 0 else {
                let error: CommentServiceError = .failedToWrite(message: "New comment not found")
                self.output?.interactorDidFinish(with: error)
                return
            }
            
            let comment = list.comments[0]
            
            guard let user = list.users[comment.userId] else {
                let error: CommentServiceError = .failedToWrite(message: "Author not found")
                self.output?.interactorDidFinish(with: error)
                return
            }
            
            var data = CommentWriterDataItem()
            data.id = comment.id
            data.content = comment.message
            data.timestamp = comment.timestamp
            data.authorName = user.displayName
            data.authorAvatar = user.avatarUrl
            data.authorId = user.id
            
            self.output?.interactorDidFinish(with: data)
        }
    }
}
