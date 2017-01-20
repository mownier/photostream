//
//  PostLikePresenter.swift
//  Photostream
//
//  Created by Mounir Ybanez on 20/01/2017.
//  Copyright © 2017 Mounir Ybanez. All rights reserved.
//

protocol PostLikePresenterInterface: BaseModulePresenter, BaseModuleInteractable {
    
    var postId: String { set get }
    var limit: UInt { set get }
    var likes: [PostLikeDisplayData] { set get }
    
    func append(itemsOf data: [PostLikeData])
    func index(of userId: String) -> Int?
}

class PostLikePresenter: PostLikePresenterInterface {
    
    typealias ModuleView = PostLikeScene
    typealias ModuleInteractor = PostLikeInteractorInput
    typealias ModuleWireframe = PostLikeWireframeInterface
    
    weak var view: ModuleView!
    var interactor: ModuleInteractor!
    var wireframe: ModuleWireframe!
    
    var postId: String = ""
    var limit: UInt = 20
    var likes = [PostLikeDisplayData]()
    
    func append(itemsOf data: [PostLikeData]) {
        let filtered = data.filter { data -> Bool in
            return index(of: data.userId) == nil
        }
        
        for entry in filtered {
            var item = PostLikeDisplayDataItem()
            item.avatarUrl = entry.avatarUrl
            item.displayName = entry.displayName
            item.isFollowing = entry.isFollowing
            item.isMe = entry.isMe
            item.userId = entry.userId
            
            likes.append(item)
        }
    }
    
    func index(of userId: String) -> Int? {
        return likes.index { displayData -> Bool in
            return displayData.userId == userId
        }
    }
}

extension PostLikePresenter: PostLikeModuleInterface {
    
    var likeCount: Int {
        return likes.count
    }
    
    func exit() {
        var property = WireframeExitProperty()
        property.controller = view.controller
        wireframe.exit(with: property)
    }
    
    func like(at index: Int) -> PostLikeDisplayData? {
        guard likes.isValid(index) else {
            return nil
        }
        
        return likes[index]
    }
    
    func viewDidLoad() {
        initialLoad()
    }
    
    func initialLoad() {
        view.isLoadingViewHidden = false
        view.isEmptyViewHidden = true
        interactor.fetchNew(postId: postId, limit: limit)
    }
    
    func refresh() {
        view.isRefreshingViewHidden = false
        view.isEmptyViewHidden = true
        interactor.fetchNew(postId: postId, limit: limit)
    }
    
    func loadMore() {
        interactor.fetchNext(postId: postId, limit: limit)
    }
    
    func toggleFollow(at index: Int) {
        guard let like = like(at: index) else {
            return
        }
        
        if like.isFollowing {
            unfollow(at: index)
            
        } else {
            follow(at: index)
        }
    }
    
    func follow(at index: Int) {
        guard var like = like(at: index) else {
            view.didFollow(error: "Can not follow user rignt now")
            return
        }
        
        like.isBusy = true
        likes[index] = like
        
        view.reload(at: index)
        
        interactor.follow(userId: like.userId)
    }
    
    func unfollow(at index: Int) {
        guard var like = like(at: index) else {
            view.didUnfollow(error: "Can not unfollow user rignt now")
            return
        }
        
        like.isBusy = true
        likes[index] = like
        
        view.reload(at: index)
        
        interactor.unfollow(userId: like.userId)
    }
}

extension PostLikePresenter: PostLikeInteractorOutput {
    
    func didFetchNew(data: [PostLikeData]) {
        view.isLoadingViewHidden = true
        view.isRefreshingViewHidden = true
        
        likes.removeAll()
        
        append(itemsOf: data)
        
        if likeCount == 0 {
            view.isEmptyViewHidden = false
        }
        
        view.didRefresh(error: nil)
        view.reload()
    }
    
    func didFetchNext(data: [PostLikeData]) {
        view.didLoadMore(error: nil)
        
        guard data.count > 0 else {
            return
        }
        
        append(itemsOf: data)
        
        view.reload()
    }
    
    func didFetchNew(error: PostServiceError) {
        view.isLoadingViewHidden = true
        view.isRefreshingViewHidden = true
        
        view.didRefresh(error: error.message)
    }
    
    func didFetchNext(error: PostServiceError) {
        view.didLoadMore(error: error.message)
    }
    
    func didFollow(error: UserServiceError?, userId: String) {
        if let index = index(of: userId) {
            var like = likes[index]
            like.isBusy = false
            
            if error == nil {
                like.isFollowing = true
            }
            
            likes[index] = like
            
            view.reload(at: index)
        }
        
        view.didFollow(error: error?.message)
    }
    
    func didUnfollow(error: UserServiceError?, userId: String) {
        if let index = index(of: userId) {
            var like = likes[index]
            like.isBusy = false
            
            if error == nil {
                like.isFollowing = false
            }
            
            likes[index] = like
            
            view.reload(at: index)
        }
        
        view.didUnfollow(error: error?.message)
    }
}
