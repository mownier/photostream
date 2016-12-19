//
//  UserProfileViewController.swift
//  Photostream
//
//  Created by Mounir Ybanez on 10/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {
    
    var userProfileView: UserProfileView!
    var presenter: UserProfileModuleInterface!
    
    override func loadView() {
        let frame = CGRect(origin: .zero, size: UIScreen.main.bounds.size)
        userProfileView = UserProfileView()
        userProfileView.frame = frame
        userProfileView.delegate = self
        view = userProfileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.fetchUserProfile()
    }
}

extension UserProfileViewController: UserProfileScene {
    
    var controller: UIViewController? {
        return self
    }
    
    func didFetchUserProfile(with data: UserProfileData) {
        update(with: data)
    }
    
    func didFollow(with data: UserProfileData) {
        update(with: data)
    }
    
    func didUnfollow(with data: UserProfileData) {
        update(with: data)
    }
    
    func didFetchUserProfile(with error: String?) {
        
    }
    
    func didFollow(with error: String) {
        
    }
    
    func didUnfollow(with error: String) {
        
    }
    
    private func update(with data: UserProfileData) {
        let item = data as? UserProfileViewItem
        userProfileView.configure(wiht: item)
    }
}

extension UserProfileViewController: UserProfileViewDelegate {
    
    func willEdit(view: UserProfileView) {
        
    }
    
    func willFollow(view: UserProfileView) {
        presenter.follow()
    }
    
    func willUnfollow(view: UserProfileView) {
        presenter.unfollow()
    }
}


