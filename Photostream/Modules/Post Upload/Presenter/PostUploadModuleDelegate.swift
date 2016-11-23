//
//  PostUploadModuleDelegate.swift
//  Photostream
//
//  Created by Mounir Ybanez on 19/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

protocol PostUploadModuleDelegate: class {

    func postUploadDidRetry()
    func postUploadDidFail(with message: String)
    func postUploadDidSucceed(with post: UploadedPost)
}
