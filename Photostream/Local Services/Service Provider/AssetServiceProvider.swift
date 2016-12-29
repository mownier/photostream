//
//  AssetServiceProvider.swift
//  Photostream
//
//  Created by Mounir Ybanez on 11/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit
import Photos

class AssetServiceProvider: NSObject, AssetService {

    fileprivate var fetchResult: PHFetchResult<PHAsset>?
    
    weak var observer: AssetServiceObserver?
    
    override init() {
        super.init()
        
        PHPhotoLibrary.shared().register(self)
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    func fetchImageAssets(with options: PHFetchOptions?, completion: (([PHAsset]) -> Void)?) {
        let result = PHAsset.fetchAssets(with: .image, options: options)
        var assets = [PHAsset]()
        result.enumerateObjects({ (asset, _, _) in
            assets.append(asset)
        })
        completion?(assets)
        fetchResult = result
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

extension AssetServiceProvider: PHPhotoLibraryChangeObserver {
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        DispatchQueue.main.sync {
            guard let result = fetchResult,
                let details = changeInstance.changeDetails(for: result) else {
                return
            }
            
            fetchResult = details.fetchResultAfterChanges
            var assets = [PHAsset]()
            fetchResult!.enumerateObjects({ (asset, _, _) in
                assets.append(asset)
            })
            observer?.assetServiceDidChange(assets: assets)
        }
    }
}
