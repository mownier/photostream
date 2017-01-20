//
//  FollowListPresenter.swift
//  Photostream
//
//  Created by Mounir Ybanez on 17/01/2017.
//  Copyright © 2017 Mounir Ybanez. All rights reserved.
//

protocol FollowListPresenterInterface: BaseModulePresenter, BaseModuleInteractable, BaseModuleDelegatable {
    
    var userId: String { set get }
    var limit: UInt { set get }
    var fetchType: FollowListFetchType { set get }
    var list: [FollowListDisplayData] { set get }
    var isMe: Bool { set get }
    
    func append(itemsOf data: [FollowListData])
    func index(of userId: String) -> Int?
}

class FollowListPresenter: FollowListPresenterInterface {

    typealias ModuleView = FollowListScene
    typealias ModuleInteractor = FollowListInteractorInput
    typealias ModuleWireframe = FollowListWireframeInterface
    typealias ModuleDelegate = FollowListDelegate

    weak var delegate: ModuleDelegate?
    weak var view: ModuleView!
    var interactor: ModuleInteractor!
    var wireframe: ModuleWireframe!
    
    var userId: String = ""
    var limit: UInt = 20
    var fetchType: FollowListFetchType = .following
    var list = [FollowListDisplayData]()
    var isMe: Bool = false
    
    func append(itemsOf data: [FollowListData]) {
        for entry in data {
            guard index(of: entry.userId) == nil else {
                return
            }
            
            var item = FollowListDisplayDataItem()
            item.avatarUrl = entry.avatarUrl
            item.displayName = entry.displayName
            item.isFollowing = entry.isFollowing
            item.isMe = entry.isMe
            item.userId = entry.userId
            
            list.append(item)
        }
    }
    
    func index(of userId: String) -> Int? {
        return list.index { displayData -> Bool in
            return displayData.userId == userId
        }
    }
}

extension FollowListPresenter: FollowListModuleInterface {
    
    var listCount: Int {
        return list.count
    }
    
    var navigationItemTitle: String {
        switch fetchType {
        
        case .followers:
            return "Followers"
        
        case .following:
            return "Following"
        }
    }
    
    func exit() {
        var property = WireframeExitProperty()
        property.controller = view.controller
        wireframe.exit(with: property)
    }
    
    func listItem(at index: Int) -> FollowListDisplayData? {
        guard list.isValid(index) else {
            return nil
        }
        
        return list[index]
    }
    
    func viewDidLoad() {
        initialLoad()
    }
    
    func initialLoad() {
        view.isLoadingViewHidden = false
        view.isEmptyViewHidden = true
        interactor.fetchNew(userId: userId, type: fetchType, limit: limit)
    }
    
    func refresh() {
        view.isRefreshingViewHidden = false
        view.isEmptyViewHidden = true
        interactor.fetchNew(userId: userId, type: fetchType, limit: limit)
    }
    
    func loadMore() {
        interactor.fetchNext(userId: userId, type: fetchType, limit: limit)
    }
    
    func toggleFollow(at index: Int) {
        guard let listItem = listItem(at: index) else {
            return
        }
        
        if listItem.isFollowing {
            unfollow(at: index)
            
        } else {
            follow(at: index)
        }
    }
    
    func follow(at index: Int) {
        guard var listItem = listItem(at: index) else {
            view.didFollow(with: "Can not follow user rignt now")
            return
        }
        
        listItem.isBusy = true
        list[index] = listItem
        
        view.reloadItem(at: index)
        
        interactor.follow(userId: listItem.userId)
    }
    
    func unfollow(at index: Int) {
        guard var listItem = listItem(at: index) else {
            view.didUnfollow(with: "Can not unfollow user rignt now")
            return
        }
        
        listItem.isBusy = true
        list[index] = listItem
        
        view.reloadItem(at: index)
        
        interactor.unfollow(userId: listItem.userId)
    }
}

extension FollowListPresenter: FollowListInteractorOutput {
    
    func didFetchNew(with data: [FollowListData]) {
        view.isLoadingViewHidden = true
        view.isRefreshingViewHidden = true
        
        list.removeAll()
        
        append(itemsOf: data)
        
        if list.count == 0 {
            view.isEmptyViewHidden = false
        }
        
        view.didRefresh(with: nil)
        view.reload()
    }
    
    func didFetchNext(with data: [FollowListData]) {
        view.didLoadMore(with: nil)
        
        guard data.count > 0 else {
            return
        }
        
        append(itemsOf: data)
        
        view.reload()
    }
    
    func didFetchNew(with error: UserServiceError) {
        view.isLoadingViewHidden = true
        view.isRefreshingViewHidden = true
        
        view.didRefresh(with: error.message)
    }
    
    func didFetchNext(with error: UserServiceError) {
        view.didLoadMore(with: error.message)
    }
    
    func didFollow(with error: UserServiceError?, userId: String) {
        if let index = index(of: userId) {
            var item = list[index]
            item.isBusy = false
            
            if error == nil {
                item.isFollowing = true
            }
            
            list[index] = item
            
            view.reloadItem(at: index)
        }
        
        view.didFollow(with: error?.message)
        
        if error == nil {
            delegate?.followListDidFollow(isMe: isMe)
        }
    }
    
    func didUnfollow(with error: UserServiceError?, userId: String) {
        if let index = index(of: userId) {
            var item = list[index]
            item.isBusy = false
            
            if error == nil {
                item.isFollowing = false
            }
            
            list[index] = item
            
            view.reloadItem(at: index)
        }
        
        view.didUnfollow(with: error?.message)
        
        if error == nil {
            delegate?.followListDidUnfollow(isMe: isMe)
        }
    }
}
