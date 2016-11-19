//
//  PostUploadPresenter.swift
//  Photostream
//
//  Created by Mounir Ybanez on 19/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class PostUploadPresenter: PostUploadPresenterInterface {

    weak var moduleDelegate: PostUploadModuleDelegate?
    weak var view: PostUploadViewInterface!
    var wireframe: PostUploadWireframeInterface!
    
    var image: UIImage!
    var content: String!
}

extension PostUploadPresenter: PostUploadModuleInterface {
    
    func upload() {
    
    }
}
