//
//  CommentService.swift
//  Photostream
//
//  Created by Mounir Ybanez on 08/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

protocol CommentService {

    init(session: AuthSession)
    
    func fetchComments(postId: String, offset: String, limit: UInt, callback: ((CommentServiceResult) -> Void)?)
    func writeComment(postId: String, message: String, callback: ((CommentServiceResult) -> Void)?)
}

struct CommentServiceResult {

    var comments: CommentList?
    var error: CommentServiceError?
    var nextOffset: String?
}

enum CommentServiceError: Error {
    
    case authenticationNotFound(message: String)
    case failedToFetch(message: String)
    case failedToWrite(message: String)
    
    var message: String {
        switch self {
        case .authenticationNotFound(let message),
             .failedToFetch(let message),
             .failedToWrite(let message):
            return message
        }
    }
}
