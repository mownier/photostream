//
//  ProfileEditViewController.swift
//  Photostream
//
//  Created by Mounir Ybanez on 07/01/2017.
//  Copyright © 2017 Mounir Ybanez. All rights reserved.
//

import UIKit

class ProfileEditViewController: UITableViewController {
    
    var presenter: ProfileEditModuleInterface!
    
    convenience init() {
        self.init(style: .grouped)
    }
    
    override func loadView() {
        super.loadView()
        
        let headerView = ProfileEditHeaderView()
        headerView.frame.size.width = tableView.frame.width
        headerView.delegate = self
        
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = UIView()
    }
}

extension ProfileEditViewController: ProfileEditHeaderViewDelegate {
    
    func didTapToChangeAvatar() {
        
    }
}

extension ProfileEditViewController: ProfileEditScene {
    
    var controller: UIViewController? {
        return self
    }
    
    func showProfile(with data: ProfileEditData) {
        
    }
    
    func didUpdate(with error: String?) {
        
    }
    
    func didUpload(with error: String?) {
        
    }
    
    func didUploadWith(progress: Progress) {
        
    }
}
