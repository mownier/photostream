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
    
    required init(root: RootWireframeInterface?, delegate: PostUploadModuleDelegate?, view: PostUploadViewInterface, item: PostUploadItem) {
        self.root = root
        
        let auth = AuthSession()
        let fileService = FileServiceProvider(session: auth)
        let postService = PostServiceProvider(session: auth)
        let interactor = PostUploadInteractor(fileService: fileService, postService: postService)
        let presenter = PostUploadPresenter()
        
        interactor.output = presenter
        view.presenter = presenter
        
        presenter.item = item
        presenter.view = view
        presenter.interactor = interactor
        presenter.moduleDelegate = delegate
        presenter.wireframe = self
    }
    
    func attach(with controller: UIViewController, in parent: UIViewController) {
        parent.view.addSubview(controller.view)
        parent.addChildViewController(controller)
        controller.didMove(toParentViewController: parent)
    }
    
    func detach(with controller: UIViewController) {
        controller.view.removeFromSuperview()
        controller.removeFromParentViewController()
        controller.didMove(toParentViewController: nil)
    }
}
