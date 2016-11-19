//
//  PhotoSharePresenter.swift
//  Photostream
//
//  Created by Mounir Ybanez on 18/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class PhotoSharePresenter: PhotoSharePresenterInterface {

    weak var moduleDelegate: PhotoShareModuleDelegate?
    weak var view: PhotoShareViewInterface!
    var wireframe: PhotoShareWireframeInterface!
}

extension PhotoSharePresenter: PhotoShareModuleInterface {
    
    func cancel() {
        moduleDelegate?.photoShareDidCancel()
    }
    
    func finish(with image: UIImage, content: String) {
        moduleDelegate?.photoShareDidFinish(with: image, content: content)
    }
    
    func pop(animated: Bool) {
        wireframe.pop(from: view.controller?.navigationController, animated: animated)
    }
    
    func dismiss(animated: Bool, completion: (() -> Void)?) {
        wireframe.dismiss(with: view.controller, animated: animated, completion: completion)
    }
}
