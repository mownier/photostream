//
//  PostUploadPresenterInterface.swift
//  Photostream
//
//  Created by Mounir Ybanez on 19/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

protocol PostUploadPresenterInterface: class {

    var interactor: PostUploadInteractorInput! { set get }
    var view: PostUploadViewInterface! { set get }
    var wireframe: PostUploadWireframeInterface! { set get }
    var moduleDelegate: PostUploadModuleDelegate? { set get }
    var item: PostUploadItem! { set get }
}
