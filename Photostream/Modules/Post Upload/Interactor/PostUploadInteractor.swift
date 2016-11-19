//
//  PostUploadInteractor.swift
//  Photostream
//
//  Created by Mounir Ybanez on 19/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class PostUploadInteractor: PostUploadInteractorInterface {

    weak var output: PostUploadInteractorOutput?
    var fileService: FileService!
    var postService: PostService!
    
    required init(fileService: FileService, postService: PostService) {
        self.fileService = fileService
        self.postService = postService
    }
}

extension PostUploadInteractor: PostUploadInteractorInput {
    
    func upload(with data: FileServiceImageUploadData, content: String) {

    }
    
    func cancel() {
        
    }
}
