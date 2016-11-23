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
    var interactor: PostUploadInteractorInput!
    
    var image: UIImage!
    var content: String!
}

extension PostUploadPresenter: PostUploadModuleInterface {
    
    func upload() {
        var data = FileServiceImageUploadData()
        data.data = UIImageJPEGRepresentation(image, 1.0)
        data.width = Float(image.size.width)
        data.height = Float(image.size.height)
        interactor.upload(with: data, content: content)
    }
    
    func willShowImage() {
        view.show(image: image)
    }
}

extension PostUploadPresenter: PostUploadInteractorOutput {
    
    func didFail(with message: String) {
        moduleDelegate?.postUploadDidFail(with: message)
        view.didFail(with: message)
    }
    
    func didSucceed(with post: UploadedPost) {
        moduleDelegate?.postUploadDidSucceed(with: post)
        view.didSucceed()
    }
    
    func didUpdate(with progress: Progress) {
        
    }
}
