//
//  MultilineEditorWireframe.swift
//  Photostream
//
//  Created by Mounir Ybanez on 16/01/2017.
//  Copyright © 2017 Mounir Ybanez. All rights reserved.
//

protocol MultilineEditorWireframeInterface: BaseModuleWireframe { }

class MultilineEditorWireframe: MultilineEditorWireframeInterface  {
    
    var root: RootWireframe?
    var style: WireframeStyle!
    
    required init(root: RootWireframe?) {
        self.root = root
    }
}
