//
//  PhotoLibraryInteractor.swift
//  Photostream
//
//  Created by Mounir Ybanez on 11/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class PhotoLibraryInteractor: PhotoLibraryInteractorInterface {

    weak var output: PhotoLibraryInteractorOutput?
    var service: AssetService!
    
    required init(service: AssetService) {
        self.service = service
    }
}

extension PhotoLibraryInteractor: PhotoLibraryInteractorInput {
    
    func fetchPhotos() {
        service.fetchImageAssets { (assets) in
            self.output?.photoLibraryDidFetchPhotos(with: assets)
        }
    }
    
    func fetchPhoto(for data: AssetRequestData, completion: ((UIImage?) -> Void)?) {
        service.fetchImage(for: data) { (image) in
            completion?(image)
        }
    }
}
