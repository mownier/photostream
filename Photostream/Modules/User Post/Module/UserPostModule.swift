//
//  UserPostModule.swift
//  Photostream
//
//  Created by Mounir Ybanez on 06/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

protocol UserPostModuleInterface: BaseModuleInterface {
    
    var postCount: Int { get }
    
    func refreshPosts()
    func loadMorePosts()
    
    func unlikePost(at index: Int)
    func likePost(at index: Int)
    
    func post(at index: Int) -> UserPostData?
}
