//
//  ProfileEditViewController.swift
//  Photostream
//
//  Created by Mounir Ybanez on 07/01/2017.
//  Copyright © 2017 Mounir Ybanez. All rights reserved.
//

import UIKit

class ProfileEditViewController: UITableViewController {
    
    lazy var header: ProfileEditHeaderView = ProfileEditHeaderView()
    
    var presenter: ProfileEditModuleInterface!
    
    var displayData: ProfileEditData?
    
    convenience init() {
        self.init(style: .grouped)
    }
    
    override func loadView() {
        super.loadView()
        
        header.frame.size.width = tableView.frame.width
        header.delegate = self
        
        tableView.allowsSelection = false
        tableView.tableHeaderView = header
        tableView.tableFooterView = UIView()
        
        setupNavigationItem()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
    
    func setupNavigationItem() {
        navigationItem.title = "Edit Profile"
        
        let barItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back_nav_icon"), style: .plain, target: self, action: #selector(self.back))
        navigationItem.leftBarButtonItem = barItem
    }
    
    func back() {
        presenter.exit()
    }
}

extension ProfileEditViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard displayData != nil else {
            return 0
        }
        
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var reuseId: String?
        var text: String?
        
        switch indexPath.row {
            
        case 0:
            reuseId = "UsernameCell"
            text = displayData?.username

        case 1:
            reuseId = "FirstNameCell"
            text = displayData?.firstName
            
        case 2:
            reuseId = "LastNameCell"
            text = displayData?.lastName
            
        case 3:
            reuseId = "BioCell"
            text = displayData?.bio
            
        default:
            break
        }
        
        guard reuseId != nil else {
            return UITableViewCell()
        }
        
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseId!)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: reuseId!)
            cell!.textLabel?.font = UIFont.systemFont(ofSize: 14)
        }
        
        cell!.textLabel?.text = text
        
        return cell!
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
        displayData = data
        
        let item = data as? ProfileEditHeaderViewItem
        header.configure(with: item)
    }
    
    func didUpdate(with error: String?) {
        
    }
    
    func didUpload(with error: String?) {
        
    }
    
    func didUploadWith(progress: Progress) {
        
    }
}
