//
//  UserActivityModule.swift
//  Photostream
//
//  Created by Mounir Ybanez on 23/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

protocol UserActivityModuleInterface: BaseModuleInterface {
    
    var activityCount: Int { get }
    
    func viewDidLoad()
    func refreshActivities()
    func loadMoreActivities()
    
    func activity(at index: Int) -> UserActivityData?
}
