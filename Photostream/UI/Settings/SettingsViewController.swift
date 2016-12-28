//
//  SettingsViewController.swift
//  Photostream
//
//  Created by Mounir Ybanez on 14/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    let reuseId = "Cell"
    
    var presenter: SettingsModuleInterface!
    
    convenience init() {
        self.init(style: .grouped)
    }
    
    override func loadView() {
        super.loadView()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseId)
        
        setupNavigationItem()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.sectionCount
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.itemCount(for: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId)!
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = presenter.itemName(at: indexPath.row, for: indexPath.section)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let itemName = presenter.itemName(at: indexPath.row, for: indexPath.section)
        
        if itemName.lowercased() == "log out" {
            presenter.presentLogout()
        }
    }
    
    func setupNavigationItem() {
        navigationItem.title = "Settings"
        
        let barItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back_nav_icon"), style: .plain, target: self, action: #selector(self.didTapBack))
        navigationItem.leftBarButtonItem = barItem
    }
}

extension SettingsViewController {
    
    func didTapBack() {
        presenter.exit()
    }
}

extension SettingsViewController: SettingsScene {
    
    var controller: UIViewController? {
        return self
    }
}



