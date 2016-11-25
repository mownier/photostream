//
//  PhotoLibraryPresenter.swift
//  Photostream
//
//  Created by Mounir Ybanez on 11/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Photos

class PhotoLibraryPresenter: PhotoLibraryPresenterInterface {

    weak var view: PhotoLibraryViewInterface!
    weak var moduleDelegate: PhotoLibraryModuleDelegate?
    weak var cropper: PhotoCropper!
    
    var wireframe: PhotoLibraryWireframeInterface!
    var interactor: PhotoLibraryInteractorInput!
    var photos = [PHAsset]()
    var contentMode: PhotoContentMode = .fill(false) {
        didSet {
            switch contentMode {
            case .fill(let animated):
                view.showSelectedPhotoInFillMode(animated: animated)
            case.fit(let animated):
                view.showSelectedPhotoInFitMode(animated: animated)
            }
        }
    }
}

extension PhotoLibraryPresenter: PhotoLibraryModuleInterface {
    
    var photoCount: Int {
        return photos.count
    }
    
    func fetchPhotos() {
        interactor.fetchPhotos()
    }
    
    func photo(at index: Int) -> PHAsset? {
        guard photos.isValid(index) else {
            return nil
        }
        
        return photos[index]
    }
    
    func willShowSelectedPhoto(at index: Int, size: CGSize) {
        guard let asset = photo(at: index) else {
            self.view.showSelectedPhoto(with: nil)
            return
        }
        
        var data = AssetRequestData()
        data.asset = asset
        data.size = size
        data.mode = .aspectFit
        
        interactor.fetchPhoto(for: data) { (image) in
            self.view.showSelectedPhoto(with: image)
        }
    }
    
    func fetchThumbnail(at index: Int, size: CGSize, completion: ((UIImage?) -> Void)?) {
        guard let asset = photo(at: index) else {
            completion?(nil)
            return
        }
        
        var data = AssetRequestData()
        data.asset = asset
        data.size = size
        
        interactor.fetchPhoto(for: data) { (image) in
            completion?(image)
        }
    }
    
    func set(photoCropper: PhotoCropper) {
        cropper = photoCropper
    }
    
    func cancel() {
        moduleDelegate?.photoLibraryDidCancel()
    }
    
    func done() {
        moduleDelegate?.photoLibraryDidPick(with: cropper.image)
    }
    
    func fillSelectedPhoto(animated: Bool) {
        contentMode = .fill(animated)
    }
    
    func fitSelectedPhoto(animated: Bool) {
        contentMode = .fit(animated)
    }
    
    func toggleContentMode(animated: Bool) {
        switch contentMode {
        case .fill:
            contentMode = .fit(animated)
        case .fit:
            contentMode = .fill(animated)
        }
    }
    
    func dismiss(animated: Bool) {
        wireframe.dismiss(with: view.controller)
    }
}

extension PhotoLibraryPresenter: PhotoLibraryInteractorOutput {

    func photoLibraryDidFetchPhotos(with assets: [PHAsset]) {
        photos.append(contentsOf: assets)
        view.didFetchPhotos()
    }
}
