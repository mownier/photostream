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
    
    lazy var savingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .white)
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        view.hidesWhenStopped = true
        return view
    }()
    
    var presenter: ProfileEditModuleInterface!
    var displayItems = [ProfileEditDisplayItem]()
    
    var isSavingViewHidden: Bool = false {
        didSet {
            savingView.frame = view.bounds
            
            if isSavingViewHidden {
                savingView.removeFromSuperview()
                savingView.stopAnimating()
                navigationItem.rightBarButtonItem!.isEnabled = true
                
            } else {
                view.addSubview(savingView)
                savingView.startAnimating()
                navigationItem.rightBarButtonItem!.isEnabled = false
            }
        }
    }
    
    convenience init() {
        self.init(style: .grouped)
    }
    
    override func loadView() {
        super.loadView()
        
        header.frame.size.width = tableView.frame.width
        header.delegate = self
        
        tableView.tableHeaderView = header
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        
        setupNavigationItem()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(stopEditing))
        tap.numberOfTapsRequired = 1
        tap.cancelsTouchesInView = false
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
        stopEditing()
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
    
    func willUpload(image: UIImage) {
        header.avatarImageView.image = image
        header.progressView.isHidden = false
    }
    
    func didUpdate(with error: String?) {
        guard error != nil else {
            return
        }
        
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func didUpload(with error: String?) {
        header.progressView.isHidden = true
        
        if error != nil {
            let item = presenter.updateData as? ProfileEditHeaderViewItem
            header.configure(with: item)
        }
    }
    
    func didUploadWith(progress: Progress) {
        let percent = Int(progress.fractionCompleted * 100)
        header.progressView.text = "\(percent) %"
    }
    
    func reloadDisplayItem(at index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
}
