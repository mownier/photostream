//
//  PhotoPickerPresenter.swift
//  Photostream
//
//  Created by Mounir Ybanez on 11/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit
import Photos

class PhotoPickerPresenter: PhotoPickerPresenterInterface {

    weak var view: PhotoPickerViewInterface!
    weak var moduleDelegate: PhotoPickerModuleDelegate?
    
    var wireframe: PhotoPickerWireframeInterface!
    var interactor: PhotoPickerInteractorInput!
    var photos = [PHAsset]()
}

extension PhotoPickerPresenter: PhotoPickerModuleInterface {
    
    func fetchImageAssets() {
        interactor.fetchImageAssets()
    }
    
    func photo(at index: Int) -> PHAsset? {
        guard photos.isValid(index) else {
            return nil
        }
        
        return photos[index]
    }
}

extension PhotoPickerPresenter: PhotoPickerInteractorOutput {
    
    func photoPickerDidFetchImage(with assets: [PHAsset]) {
        photos.append(contentsOf: assets)
        view.didFetchImageAssets()
    }
}
