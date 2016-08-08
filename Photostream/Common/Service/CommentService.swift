//
//  CommentService.swift
//  Photostream
//
//  Created by Mounir Ybanez on 08/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

typealias CommentServiceCallback = ([Comment]?, NSError?) -> Void

class CommentService: AnyObject {

    var source: CommentServiceSource!
    
    init(source: CommentServiceSource!) {
        self.source = source
    }
    
    func get(postId: String!, offset: UInt!, limit: UInt!, callback: CommentServiceCallback!) {
        source.get(postId, offset: offset, limit: limit) { (comments, error) in
            callback(comments, error)
        }
    }
    
    func post(postId: String!, message: String!, user: User!, callback: CommentServiceCallback!) {
        source.post(postId, message: message, user: user) { (comments, error) in
            callback(comments, error)
        }
    }
}

protocol CommentServiceSource: class {
    
    func get(postId: String!, offset: UInt!, limit: UInt!, callback: CommentServiceCallback!)
    func post(postId: String!, message: String!, user: User!, callback: CommentServiceCallback!)
}
