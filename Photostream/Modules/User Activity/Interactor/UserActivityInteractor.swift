//
//  UserActivityInteractor.swift
//  Photostream
//
//  Created by Mounir Ybanez on 22/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

protocol UserActivityInteractorInput: BaseModuleInteractorInput {
    
    func fetchNew(with userId: String, limit: UInt)
    func fetchNext(with userId: String, limit: UInt)
}

protocol UserActivityInteractorOutput: BaseModuleInteractorOutput {
    
    func userActivityDidRefresh(with data: [UserActivityData])
    func userActivityDidLoadMore(with data: [UserActivityData])
    
    func userActivityDidRefresh(with error: UserServiceError)
    func userActivityDidLoadMore(with error: UserServiceError)
}

protocol UserActivityInteractorInterface: BaseModuleInteractor {
    
    var service: UserService! { set get }
    var offset: String? { set get }
    var isFetching: Bool { set get }
    
    init(service: UserService)
    
    func fetchActivities(userId: String, limit: UInt)
}

class UserActivityInteractor: UserActivityInteractorInterface {

    typealias Output = UserActivityInteractorOutput
    
    weak var output: Output?
    
    var service: UserService!
    var offset: String?
    var isFetching: Bool = false
    
    required init(service: UserService) {
        self.service = service
    }
    
    func fetchActivities(userId: String, limit: UInt) {
        guard !isFetching, offset != nil, output != nil else {
            return
        }
        
        service.fetchActivities(id: userId, offset: offset!, limit: limit) {
            [weak self] result in
            guard result.error == nil else {
                self?.didFetch(with: result.error!)
                return
            }
            
            guard let list = result.list, list.count > 0 else {
                self?.didFetch(with: [UserActivityData]())
                self?.offset = nil
                return
            }
            
            var data = [UserActivityData]()
            
            for activity in list.activities {
                switch activity.type {
                
                case .like(let userId, let postId),
                     .post(let userId, let postId):
                    guard let user = list.users[userId],
                        let post = list.posts[postId] else {
                        continue
                    }
                    
                    var item: UserActivityData?
                    
                    switch activity.type {
                    
                    case .like:
                        item = UserActivityLikeDataItem(user: user, post: post)
                    
                    case .post:
                        item = UserActivityPostDataItem(user: user, post: post)
                        
                    default:
                        break
                    }
                    
                    if item != nil {
                        item!.timestamp = activity.timestamp
                        data.append(item!)
                    }
                
                case .comment(let userId, let commentId, let postId):
                    guard let user = list.users[userId],
                        let comment = list.comments[commentId],
                        let post = list.posts[postId] else {
                        continue
                    }
                    
                    var item = UserActivityCommentDataItem(
                        user: user,
                        comment: comment,
                        post: post
                    )
                    
                    item.timestamp = activity.timestamp
                    data.append(item)
                
                case .follow(let userId):
                    guard let user = list.users[userId] else {
                        continue
                    }
                    
                    var item = UserActivityFollowDataItem(user: user)
                    item.timestamp = activity.timestamp
                    item.isFollowing = list.following.contains(userId)
                    data.append(item)
                    
                default:
                    break
                }
            }
            
            self?.didFetch(with: data)
            self?.offset = result.nextOffset
        }
    }
    
    private func didFetch(with error: UserServiceError) {
        if offset != nil, offset!.isEmpty {
            output?.userActivityDidRefresh(with: error)
            
        } else {
            output?.userActivityDidLoadMore(with: error)
        }
        
        isFetching = false
    }
    
    private func didFetch(with data: [UserActivityData]) {
        if offset != nil, offset!.isEmpty {
            output?.userActivityDidRefresh(with: data)
            
        } else {
            output?.userActivityDidLoadMore(with: data)
        }
        
        isFetching = false
    }
}

extension UserActivityInteractor: UserActivityInteractorInput {
    
    func fetchNew(with userId: String, limit: UInt) {
        offset = ""
        fetchActivities(userId: userId, limit: limit)
    }
    
    func fetchNext(with userId: String, limit: UInt) {
        fetchActivities(userId: userId, limit: limit)
    }
}
