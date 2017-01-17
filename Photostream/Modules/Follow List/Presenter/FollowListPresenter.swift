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
    var list: [FollowListData] { set get }
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
    var list = [FollowListData]()
}

extension FollowListPresenter: FollowListModuleInterface {
    
    var listCount: Int {
        return list.count
    }
    
    func exit() {
        var property = WireframeExitProperty()
        property.controller = view.controller
        wireframe.exit(with: property)
    }
    
    func listItem(at index: Int) -> FollowListData? {
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
    
    func follow(at index: Int) {
        guard let listItem = listItem(at: index) else {
            view.didFollow(with: "Can not follow user rignt now")
            return
        }
        
        interactor.follow(userId: listItem.userId)
    }
    
    func unfollow(at index: Int) {
        guard let listItem = listItem(at: index) else {
            view.didUnfollow(with: "Can not unfollow user rignt now")
            return
        }
        
        interactor.unfollow(userId: listItem.userId)
    }
}

extension FollowListPresenter: FollowListInteractorOutput {
    
    func didFetchNew(with data: [FollowListData]) {
        view.isLoadingViewHidden = true
        view.isRefreshingViewHidden = true
        
        list.removeAll()
        list.append(contentsOf: data)
        
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
        
        list.append(contentsOf: data)
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
    
    func didFollow(with error: UserServiceError?) {
        view.didFollow(with: error?.message)
        
        if error == nil {
            delegate?.followListDidFollow()
        }
    }
    
    func didUnfollow(with error: UserServiceError?) {
        view.didUnfollow(with: error?.message)
        
        if error == nil {
            delegate?.followListDidUnfollow()
        }
    }
}
