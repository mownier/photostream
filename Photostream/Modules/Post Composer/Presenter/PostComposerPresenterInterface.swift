//
//  PostComposerPresenterInterface.swift
//  Photostream
//
//  Created by Mounir Ybanez on 09/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

protocol PostComposerPresenterInterface: class {

    var view: PostComposerViewInterface! { set get }
    var wireframe: PostComposerWireframeInterface! { set get }
    var moduleDelegate: PostComposerModuleDelegate? { set get }
    var source: PhotoSource { set get }
}

enum PhotoSource {
    case library
    case camera
    case unknown
}
