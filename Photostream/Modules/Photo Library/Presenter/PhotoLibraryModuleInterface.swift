//
//  PhotoLibraryModuleInterface.swift
//  Photostream
//
//  Created by Mounir Ybanez on 11/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Photos

protocol PhotoLibraryModuleInterface: class {

    var photoCount: Int { get }
    
    func fetchPhotos()
    func photo(at index: Int) -> PHAsset?
    func willShowSelectedPhoto(at index: Int, size: CGSize)
    func fetchThumbnail(at index: Int, size: CGSize, completion: ((UIImage?) -> Void)?)
    
    func set(photoCropper: PhotoCropper)
    func cancel()
    func done()
    
    func fillSelectedPhoto(animated: Bool)
    func fitSelectedPhoto(animated: Bool)
    func toggleContentMode(animated: Bool)
    
    func dismiss(animated: Bool)
}

extension PhotoLibraryModuleInterface {
    
    func dismiss() {
        dismiss(animated: true)
    }
}
