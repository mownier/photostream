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
        // Upload first the photo
        fileService.uploadJPEGImage(data: data, track: { (progress) in
            guard progress != nil else {
                return
            }
            
            self.output?.didUpdate(with: progress!)
            
        }) { (result) in
            guard let url = result.fileUrl, result.error == nil else {
                self.output?.didFail(with: result.error!.message)
                return
            }
            
            // Write details of the post
            self.postService.writePost(imageUrl: url, content: content, callback: { (result) in
                guard result.error == nil else {
                    self.output?.didFail(with: result.error!.message)
                    return
                }
                
                guard let posts = result.posts,
                    posts.count > 0,
                    let (post, user) = posts[0] else {
                    self.output?.didFail(with: "New post not found.")
                    return
                }
                
                self.output?.didSucceed(with: post, and: user)
            })
        }
    }
}
