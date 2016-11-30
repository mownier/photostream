//
//  CommentWriterWireframe.swift
//  Photostream
//
//  Created by Mounir Ybanez on 30/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

protocol CommentWriterWireframeInterface: BaseModuleWireframe {
    
}

class CommentWriterWireframe: CommentWriterWireframeInterface {

    var root: RootWireframe?
    var style: WireframeStyle!
    
    required init(root: RootWireframe?) {
        self.root = root
    }
}
