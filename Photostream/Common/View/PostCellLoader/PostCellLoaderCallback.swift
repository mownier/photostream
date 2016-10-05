//
//  PostCellLoaderCallback.swift
//  Photostream
//
//  Created by Mounir Ybanez on 29/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

public protocol PostListCellLoaderCallback {

    func postCellLoaderDidLikePost(_ postId: String)
    func postCellLoaderDidUnlikePost(_ postId: String)
    func postCellLoaderWillShowLikes(_ postId: String)
    func postCellLoaderWillShowComments(_ postId: String, shouldComment: Bool)
}

public protocol PostGridCellLoaderCallback {

    func postCellLoaderWillShowPostDetails(_ postId: String)
}

public protocol PostCellLoaderScrollCallback {

    func postCellLoaderDidScrollDown(_ offsetY: CGFloat, loader: PostCellLoader)
    func postCellLoaderDidScrollUp(_ offsetY: CGFloat, loader: PostCellLoader)
}
