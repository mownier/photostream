//
//  AssetServiceProvider.swift
//  Photostream
//
//  Created by Mounir Ybanez on 11/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit
import Photos

class AssetServiceProvider: AssetService {

    func fetchImageAssets(with options: PHFetchOptions?, completion: (([PHAsset]) -> Void)?) {
        let result = PHAsset.fetchAssets(with: .image, options: options)
        var assets = [PHAsset]()
        result.enumerateObjects({ (asset, _, _) in
            assets.append(asset)
        })
        completion?(assets)
    }
    
    func fetchImage(for data: AssetRequestData, completion: ((UIImage?) -> Void)?) {
        guard let asset = data.asset else {
            completion?(nil)
            return
        }
        
        let manager = PHImageManager.default()
        manager.requestImage(for: asset, targetSize: data.size, contentMode: data.mode, options: data.options, resultHandler: { image, _ in
            completion?(image)
        })
    }
}
