//
//  PostUploadPresenter.swift
//  Photostream
//
//  Created by Mounir Ybanez on 19/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

class PostUploadPresenter: PostUploadPresenterInterface {

    weak var moduleDelegate: PostUploadModuleDelegate?
    weak var view: PostUploadViewInterface!
    var wireframe: PostUploadWireframeInterface!
    var interactor: PostUploadInteractorInput!
    var item: PostUploadItem!
}

extension PostUploadPresenter: PostUploadModuleInterface {
    
    func upload() {

        interactor.upload(with: item.imageData, content: item.content)
    }
    
    func willShowImage() {
        view.show(image: item.image)
    }
    
    func detach() {
        guard let controller = view.controller else {
            return
        }
        
        wireframe.detach(with: controller)
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
        view.didUpdate(with: progress)
    }
}
