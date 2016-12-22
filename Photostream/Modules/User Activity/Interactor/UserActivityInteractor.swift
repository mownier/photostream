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
    
    init(service: UserService)
    
    func fetchActivities(userId: String, limit: UInt)
}

class UserActivityInteractor: UserActivityInteractorInterface {

    typealias Output = UserActivityInteractorOutput
    
    weak var output: Output?
    
    var service: UserService!
    var offset: String?
    
    required init(service: UserService) {
        self.service = service
    }
    
    func fetchActivities(userId: String, limit: UInt) {
        
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
