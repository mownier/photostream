//
//  PostDiscoveryPresenter.swift
//  Photostream
//
//  Created by Mounir Ybanez on 20/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

protocol PostDiscoveryPresenterInterface: BaseModulePresenter, BaseModuleInteractable {

    var posts: [PostDiscoveryData] { set get }
    var limit: UInt { set get }
}

class PostDiscoveryPresenter: PostDiscoveryPresenterInterface {

    typealias ModuleView = PostDiscoveryScene
    typealias ModuleInteractor = PostDiscoveryInteractorInput
    typealias ModuleWireframe = PostDiscoveryWireframeInterface
    
    weak var view: ModuleView!
    
    var interactor: ModuleInteractor!
    var wireframe: ModuleWireframe!
    
    var posts = [PostDiscoveryData]()
    var limit: UInt = 50
}

extension PostDiscoveryPresenter: PostDiscoveryModuleInterface {
    
    var postCount: Int {
        return posts.count
    }
    
    func exit() {
        
    }
    
    func initialLoad() {
        
    }
    
    func refreshPosts() {
        
    }
    
    func loadMorePosts() {
        
    }
    
    func unlikePost(at index: Int) {
        
    }
    
    func likePost(at index: Int) {
        
    }
    
    func toggleLike(at index: Int) {
        
    }
    
    func post(at index: Int) -> PostDiscoveryData? {
        guard posts.isValid(index) else {
            return nil
        }
        
        return posts[index]
    }
}

extension PostDiscoveryPresenter: PostDiscoveryInteractorOutput {
    
    func postDiscoveryDidRefresh(with data: [PostDiscoveryData]) {
        
    }
    
    func postDiscoveryDidLoadMore(with data: [PostDiscoveryData]) {
        
    }
    
    func postDiscoveryDidRefresh(with error: PostServiceError) {
        
    }
    
    func postDiscoveryDidLoadMore(with error: PostServiceError) {
        
    }
    
    func postDiscoveryDidLike(with postId: String, and error: PostServiceError?) {
        
    }
    
    func postDiscoveryDidUnlike(with postId: String, and error: PostServiceError?) {
        
    }
}
