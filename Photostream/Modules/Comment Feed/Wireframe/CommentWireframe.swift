//
//  CommentWireframe.swift
//  Photostream
//
//  Created by Mounir Ybanez on 23/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

class CommentFeedWireframe: CommentFeedWireframeInterface {

    var root: RootWireframe?
    var style: WireframeStyle!
    
    required init(root: RootWireframe?) {
        self.root = root
    }
}
