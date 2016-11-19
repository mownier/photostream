//
//  PostUploadInteractorInterface.swift
//  Photostream
//
//  Created by Mounir Ybanez on 19/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

protocol PostUploadInteractorInterface: class {

    var output: PostUploadInteractorOutput? { set get }
    var fileService: FileService! { set get }
    var postService: PostService! { set get }
    
    init(fileService: FileService, postService: PostService)
}
