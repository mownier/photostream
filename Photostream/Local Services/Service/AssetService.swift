//
//  AssetService.swift
//  Photostream
//
//  Created by Mounir Ybanez on 11/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation
import Photos

protocol AssetService: class {
    
    func fetchImages(with options: PHFetchOptions?, completion: (([PHAsset]) -> Void)?)
}

extension AssetService {
    
    func fetchImages(completion: (([PHAsset]) -> Void)?) {
        let options = PHFetchOptions()
        options.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]
        fetchImages(with: options, completion: completion)
    }
}
