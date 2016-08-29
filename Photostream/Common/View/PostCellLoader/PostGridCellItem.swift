//
//  PostGridCellItem.swift
//  Photostream
//
//  Created by Mounir Ybanez on 29/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

public typealias PostGridCellItemArray = PostCellDisplayItemArray<PostGridCellItem>

public struct PostGridCellItem: PostCellDisplayItemProtocol {
    
    public var postId: String
    public var photoUrl: String
    
    init() {
        postId = ""
        photoUrl = ""
    }
}
