//
//  PhotoPickerPresenter.swift
//  Photostream
//
//  Created by Mounir Ybanez on 11/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class PhotoPickerPresenter: PhotoPickerPresenterInterface {

    weak var view: PhotoPickerViewInterface!
    weak var moduleDelegate: PhotoPickerModuleDelegate?
    
    var wireframe: PhotoPickerWireframeInterface!
    var interactor: PhotoPickerInteractorInput!
}

extension PhotoPickerPresenter: PhotoPickerModuleInterface {
    
    func fetchImageAssets() {
        interactor.fetchImageAssets()
    }
}
