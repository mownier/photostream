//
//  PostDiscoveryWireframe.swift
//  Photostream
//
//  Created by Mounir Ybanez on 20/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

protocol PostDiscoveryWireframeInterface: BaseModuleWireframe { }

class PostDiscoveryWireframe: PostDiscoveryWireframeInterface {

    var root: RootWireframe?
    var style: WireframeStyle!
    
    required init(root: RootWireframe?) {
        self.root = root
    }
}
