//
//  PostDiscoveryModule.swift
//  Photostream
//
//  Created by Mounir Ybanez on 20/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

protocol PostDicoveryModuleInterface: BaseModuleInterface {
    
    var postCount: Int { get }
    
    func initialLoad()
    func refreshPosts()
    func loadMorePosts()
    
    func unlikePost(at index: Int)
    func likePost(at index: Int)
    func toggleLike(at index: Int)
    
    func post(at index: Int) -> PostDiscoveryData?
}

class PostDiscoveryModule: AnyObject {

}
