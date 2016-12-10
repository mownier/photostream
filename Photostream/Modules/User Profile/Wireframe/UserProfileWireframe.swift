//
//  UserProfileWireframe.swift
//  Photostream
//
//  Created by Mounir Ybanez on 10/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

protocol UserProfileWireframeInterface: BaseModuleWireframe { }

class UserProfileWireframe: UserProfileWireframeInterface {

    var style: WireframeStyle!
    var root: RootWireframe?
    
    required init(root: RootWireframe?) {
        self.root = root
    }
}
