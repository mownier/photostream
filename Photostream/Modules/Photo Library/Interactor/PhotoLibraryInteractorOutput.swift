//
//  PhotoLibraryInteractorOutput.swift
//  Photostream
//
//  Created by Mounir Ybanez on 11/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Photos

protocol PhotoLibraryInteractorOutput: class {

    func photoLibraryDidFetchPhotos(with assets: [PHAsset])
}
