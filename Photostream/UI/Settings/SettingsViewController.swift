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
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.sectionCount
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.itemCount(for: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId)!
        cell.accessoryType = .detailButton
        cell.textLabel?.text = presenter.itemName(at: indexPath.row, for: indexPath.section)
        return cell
    }
}

extension SettingsViewController: SettingsScene {
    
    var controller: UIViewController? {
        return self
    }
}



