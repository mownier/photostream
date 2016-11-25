//
//  PostUploadWireframeInterface.swift
//  Photostream
//
//  Created by Mounir Ybanez on 19/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

protocol PostUploadWireframeInterface: class {

    var root: RootWireframeInterface? { set get }
    
    init(root: RootWireframeInterface?, delegate: PostUploadModuleDelegate?, view: PostUploadViewInterface, item: PostUploadItem)
    
    func attach(with controller: UIViewController, in parent: UIViewController)
    func detach(with controller: UIViewController)
}
