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
        let item = data as? UserProfileViewItem
        userProfileView.configure(wiht: item)
    }
    
    func didFetchUserProfile(with error: String?) {
        
    }
}


