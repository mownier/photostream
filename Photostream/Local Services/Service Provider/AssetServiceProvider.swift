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

    func fetchImages(completion: (([PHAsset]) -> Void)?) {
        let result = PHAsset.fetchAssets(with: .image, options: nil)
        var assets = [PHAsset]()
        result.enumerateObjects({ (object, _, _) -> Void in
            assets.append(object)
        })
        
        completion?(assets)
    }
}
