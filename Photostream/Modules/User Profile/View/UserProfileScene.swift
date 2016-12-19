//
//  UserProfileScene.swift
//  Photostream
//
//  Created by Mounir Ybanez on 10/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

protocol UserProfileScene: BaseModuleView {

    var presenter: UserProfileModuleInterface! { set get }
    
    func didFetchUserProfile(with error: String?)
    func didFetchUserProfile(with data: UserProfileData)
    
    func didFollow(with data: UserProfileData)
    func didFollow(with error: String)
    
    func didUnfollow(with data: UserProfileData)
    func didUnfollow(with error: String)
}
