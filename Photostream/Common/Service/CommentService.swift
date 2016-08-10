//
//  CommentService.swift
//  Photostream
//
//  Created by Mounir Ybanez on 08/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

typealias CommentServiceCallback = (CommentServiceResult?, NSError?) -> Void

protocol CommentService: class {

    func fetchComments(postId: String!, offset: UInt!, limit: UInt!, callback: CommentServiceCallback!)
    func writeComment(postId: String!, userId: String!, message: String!, callback: CommentServiceCallback!)
}

struct CommentServiceResult {

    var comments: [Comment]!
    var users: [String: User]!
}
