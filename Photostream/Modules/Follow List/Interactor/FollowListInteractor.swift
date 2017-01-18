//
//  FollowListInteractor.swift
//  Photostream
//
//  Created by Mounir Ybanez on 17/01/2017.
//  Copyright © 2017 Mounir Ybanez. All rights reserved.
//

protocol FollowListInteractorInput: BaseModuleInteractorInput {
    
    func fetchNew(userId: String, type: FollowListFetchType, limit: UInt)
    func fetchNext(userId: String, type: FollowListFetchType, limit: UInt)
    
    func follow(userId: String)
    func unfollow(userId: String)
}

protocol FollowListInteractorOutput: BaseModuleInteractorOutput {
    
    func didFetchNew(with data: [FollowListData])
    func didFetchNext(with data: [FollowListData])
    
    func didFetchNew(with error: UserServiceError)
    func didFetchNext(with error: UserServiceError)
    
    func didFollow(with error: UserServiceError?, userId: String)
    func didUnfollow(with error: UserServiceError?, userId: String)
}

protocol FollowListInteractorInterface: BaseModuleInteractor {
    
    var service: UserService! { set get }
    var offset: String? { set get }
    var isFetching: Bool { set get }
    
    init(service: UserService)
    
    func fetch(userId: String, type: FollowListFetchType, limit: UInt)
}

class FollowListInteractor: FollowListInteractorInterface {

    typealias Output = FollowListInteractorOutput
    
    weak var output: Output?
    var service: UserService!
    var offset: String?
    var isFetching: Bool = false
    
    required init(service: UserService) {
        self.service = service
    }
    
    func fetch(userId: String, type: FollowListFetchType, limit: UInt) {
        guard output != nil, offset != nil, !isFetching else {
            return
        }
        
        isFetching = true
        
        switch type {
        
        case .followers:
            service.fetchFollowers(id: userId, offset: offset!, limit: limit, callback: {
                [weak self] result in
                self?.didFinishFetching(result: result)
            })
        
        case .following:
            service.fetchFollowing(id: userId, offset: offset!, limit: limit, callback: {
                [weak self] result in
                self?.didFinishFetching(result: result)
            })
        }
    }
    
    fileprivate func didFinishFetching(result: UserServiceFollowListResult) {
        isFetching = false
        
        guard result.error == nil else {
            didFetch(with: result.error!)
            return
        }
        
        guard let users = result.users, users.count > 0 else {
            didFetch(with: [FollowListData]())
            return
        }
        
        var data = [FollowListData]()
        
        for user in users {
            var item = FollowListDataItem()
            
            item.avatarUrl = user.avatarUrl
            item.displayName = user.displayName
            item.userId = user.id
            
            item.isFollowing = result.following != nil && result.following![user.id] != nil
            
            if let isMe = result.following?[user.id] {
                item.isMe = isMe
            }
            
            data.append(item)
        }
        
        didFetch(with: data)
    }
    
    fileprivate func didFetch(with error: UserServiceError) {
        guard offset != nil else {
            return
        }
        
        if offset!.isEmpty {
            output?.didFetchNew(with: error)
        } else {
            output?.didFetchNext(with: error)
        }
    }
    
    fileprivate func didFetch(with data: [FollowListData]) {
        guard offset != nil else {
            return
        }
        
        if offset!.isEmpty {
            output?.didFetchNew(with: data)
        } else {
            output?.didFetchNext(with: data)
        }
    }
}

extension FollowListInteractor: FollowListInteractorInput {
    
    func fetchNew(userId: String, type: FollowListFetchType, limit: UInt) {
        offset = ""
        fetch(userId: userId, type: type, limit: limit)
    }
    
    func fetchNext(userId: String, type: FollowListFetchType, limit: UInt) {
        fetch(userId: userId, type: type, limit: limit)
    }
    
    func follow(userId: String) {
        service.follow(id: userId) { [weak self] error in
            self?.output?.didFollow(with: error, userId: userId)
        }
    }
    
    func unfollow(userId: String) {
        service.unfollow(id: userId) { [weak self] error in
            self?.output?.didUnfollow(with: error, userId: userId)
        }
    }
}
