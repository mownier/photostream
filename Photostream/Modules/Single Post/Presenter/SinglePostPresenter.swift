//
//  SinglePostPresenter.swift
//  Photostream
//
//  Created by Mounir Ybanez on 19/01/2017.
//  Copyright © 2017 Mounir Ybanez. All rights reserved.
//

protocol SinglePostPresenterInterface: BaseModulePresenter, BaseModuleInteractable {
    
    var postId: String { set get }
    var postData: SinglePostData? { set get }
}

class SinglePostPresenter: SinglePostPresenterInterface {

    typealias ModuleView = SinglePostScene
    typealias ModuleInteractor = SinglePostInteractorInput
    typealias ModuleWireframe = SinglePostWireframeInterface
    
    weak var view: ModuleView!
    var interactor: ModuleInteractor!
    var wireframe: ModuleWireframe!
    
    var postId: String = ""
    var postData: SinglePostData?
}

extension SinglePostPresenter: SinglePostModuleInterface {
    
    func exit() {
        var property = WireframeExitProperty()
        property.controller = view.controller
        wireframe.exit(with: property)
    }
    
    func viewDidLoad() {
        view.isLoadingViewHidden = false
        fetchPost()
    }
    
    func fetchPost() {
        interactor.fetchPost(id: postId)
    }
    
    func likePost() {
        guard postData != nil else {
            return
        }
        
        postData!.isLiked = true
        postData!.likes += 1
        view.reload()
        interactor.likePost(id: postId)
    }
    
    func unlikePost() {
        guard postData != nil else {
            return
        }
        
        postData!.isLiked = false
        if postData!.likes > 0 {
            postData!.likes -= 1
        }
        view.reload()
        interactor.unlikePost(id: postId)
    }
    
    func toggleLike() {
        guard postData != nil else {
            return
        }
        
        if postData!.isLiked {
            unlikePost()
            
        } else {
            likePost()
        }
    }
}

extension SinglePostPresenter: SinglePostInteractorOutput {
    
    func didFetchPost(data: SinglePostData) {
        postData = data
        view.isLoadingViewHidden = true
        view.reload()
    }
    
    func didFetchPost(error: PostServiceError) {
        view.isLoadingViewHidden = true
        view.didFetch(error: error.message)
    }
    
    func didLike(error: PostServiceError?) {
        view.didLike(error: error?.message)
    }
    
    func didUnlike(error: PostServiceError?) {
        view.didUnlike(error: error?.message)
    }
}
