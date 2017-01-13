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
    lazy var styleDefaultPrototype: ProfileEditTableCell = ProfileEditTableCell(style: .default)
    lazy var styleLineEditPrototype: ProfileEditTableCell = ProfileEditTableCell(style: .lineEdit)
    
    var presenter: ProfileEditModuleInterface!
    var displayItems = [ProfileEditDisplayItem]()
    
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
        tableView.separatorStyle = .none
        
        setupNavigationItem()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(stopEditing))
        tap.numberOfTapsRequired = 1
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
    
    func setupNavigationItem() {
        navigationItem.title = "Edit Profile"
        
        var barItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back_nav_icon"), style: .plain, target: self, action: #selector(self.back))
        navigationItem.leftBarButtonItem = barItem
        
        barItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(self.save))
        navigationItem.rightBarButtonItem = barItem
    }
    
    func back() {
        presenter.exit()
    }
    
    func save() {
        presenter.updateProfile()
    }
    
    func stopEditing() {
        view.endEditing(true)
    }
}

extension ProfileEditViewController: ProfileEditScene {
    
    var controller: UIViewController? {
        return self
    }
    
    func showProfile(with data: ProfileEditData) {
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
