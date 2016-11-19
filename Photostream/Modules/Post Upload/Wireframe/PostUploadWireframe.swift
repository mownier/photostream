//
//  PostUploadWireframe.swift
//  Photostream
//
//  Created by Mounir Ybanez on 19/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class PostUploadWireframe: PostUploadWireframeInterface {

    var root: RootWireframeInterface?
    
    required init(root: RootWireframeInterface?, delegate: PostUploadModuleDelegate?, view: PostUploadViewInterface) {
        self.root = root
    }
}
