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
    
    func fetchImageAssets(with options: PHFetchOptions?, completion: (([PHAsset]) -> Void)?)
}

extension AssetService {
    
    func fetchImageAssets(completion: (([PHAsset]) -> Void)?) {
        let options = PHFetchOptions()
        options.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]
        fetchImageAssets(with: options, completion: completion)
    }
}
