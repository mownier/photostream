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
        
        setupNavigationItem()
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
        
    }
}

extension ProfileEditViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.displayItemCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let style = cellStyle(for: indexPath.row)
        let cell = ProfileEditTableCell.dequeue(from: tableView, style: style)!
        let item = presenter.displayItem(at: indexPath.row) as? ProfileEditTableCellItem
        cell.configure(with: item)
        
        return cell
    }
    
    func cellStyle(for index: Int) -> ProfileEditTableCellStyle {
        switch index {
            
        case 0, 1, 2:
            return .lineEdit
        
        default:
            return .default
        }
    }
}

extension ProfileEditViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let style = cellStyle(for: indexPath.row)
        
        switch style {
        
        case .default:
            let item = presenter.displayItem(at: indexPath.row) as? ProfileEditTableCellItem
            styleDefaultPrototype.configure(with: item, isPrototype: true)
            return styleDefaultPrototype.dynamicHeight
            
        case .lineEdit:
            let item = presenter.displayItem(at: indexPath.row) as? ProfileEditTableCellItem
            styleLineEditPrototype.configure(with: item, isPrototype: true)
            return styleLineEditPrototype.dynamicHeight
        }
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
