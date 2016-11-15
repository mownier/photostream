//
//  PhotoPickerInteractor.swift
//  Photostream
//
//  Created by Mounir Ybanez on 11/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Photos

class PhotoPickerInteractor: PhotoPickerInteractorInterface {

    weak var output: PhotoPickerInteractorOutput?
    var service: AssetService!
    
    required init(service: AssetService) {
        self.service = service
    }
}

extension PhotoPickerInteractor: PhotoPickerInteractorInput {
    
    func fetchPhotos() {
        service.fetchImageAssets { (assets) in
            self.output?.photoPickerDidFetchPhotos(with: assets)
        }
    }
    
    func fetchPhoto(for data: AssetRequestData, completion: ((UIImage?) -> Void)?) {
        service.fetchImage(for: data) { (image) in
            completion?(image)
        }
    }
}
