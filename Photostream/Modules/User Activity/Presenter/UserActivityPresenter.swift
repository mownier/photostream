//
//  UserActivityPresenter.swift
//  Photostream
//
//  Created by Mounir Ybanez on 23/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

protocol UserActivityPresenterInterface: BaseModulePresenter, BaseModuleInteractable {
    
    var userId: String! { set get }
    var limit: UInt { set get }
    var activities: [UserActivityData] { set get }
}

class UserActivityPresenter: UserActivityPresenterInterface {
    
    typealias ModuleView = UserActivityScene
    typealias ModuleInteractor = UserActivityInteractorInput
    typealias ModuleWireframe = UserActivityWireframeInterface
    
    weak var view: ModuleView!
    
    var interactor: ModuleInteractor!
    var wireframe: ModuleWireframe!
    
    var userId: String!
    var limit: UInt = 20
    var activities = [UserActivityData]()
}

extension UserActivityPresenter: UserActivityModuleInterface {
    
    var activityCount: Int {
        return activities.count
    }
    
    func activity(at index: Int) -> UserActivityData? {
        guard activities.isValid(index) else {
            return nil
        }
        
        return activities[index]
    }
    
    func viewDidLoad() {
        view.showInitialLoadView()
        interactor.fetchNew(with: userId, limit: limit)
    }
    
    func refreshActivities() {
        view.hideEmptyView()
        view.showRefreshView()
        interactor.fetchNew(with: userId, limit: limit)
    }
    
    func loadMoreActivities() {
        interactor.fetchNext(with: userId, limit: limit)
    }
    
    func exit() {
        var property = WireframeExitProperty()
        property.controller = view.controller
        wireframe.exit(with: property)
    }
}

extension UserActivityPresenter: UserActivityInteractorOutput {
    
    func userActivityDidRefresh(with data: [UserActivityData]) {
        view.hideInitialLoadView()
        view.hideRefreshView()
        
        activities.removeAll()
        activities.append(contentsOf: data)
        
        if activityCount == 0 {
            view.showEmptyView()
        }
        
        view.didRefresh(with: nil)
        view.reloadView()

    }
    
    func userActivityDidLoadMore(with data: [UserActivityData]) {
        view.didLoadMore(with: nil)
        
        guard data.count > 0 else {
            return
        }
        
        activities.append(contentsOf: data)
        view.reloadView()
    }
    
    func userActivityDidRefresh(with error: UserServiceError) {
        view.hideInitialLoadView()
        view.hideRefreshView()
        
        view.didRefresh(with: error.message)
    }
    
    func userActivityDidLoadMore(with error: UserServiceError) {
        view.didLoadMore(with: error.message)
    }
}
