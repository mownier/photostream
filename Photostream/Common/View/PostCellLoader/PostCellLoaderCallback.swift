//
//  PostCellLoaderCallback.swift
//  Photostream
//
//  Created by Mounir Ybanez on 29/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

public protocol PostListCellLoaderCallback {
    
    func postCellLoaderDidLikePost(postId: String)
    func postCellLoaderDidUnlikePost(postId: String)
    func postCellLoaderWillShowLikes(postId: String)
    func postCellLoaderWillShowComments(postId: String, shouldComment: Bool)
}

public protocol PostGridCellLoaderCallback {
    
    func postCellLoaderWillShowPostDetails(postId: String)
}
