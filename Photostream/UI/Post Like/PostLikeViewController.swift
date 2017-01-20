//
//  PostLikeViewController.swift
//  Photostream
//
//  Created by Mounir Ybanez on 20/01/2017.
//  Copyright © 2017 Mounir Ybanez. All rights reserved.
//

import UIKit

class PostLikeViewController: UITableViewController {

    lazy var emptyView: GhostView! = {
        let view = GhostView()
        view.titleLabel.text = "No users"
        return view
    }()
    
    lazy var refreshView: UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(
            self,
            action: #selector(self.triggerRefresh),
            for: .valueChanged)
        return view
    }()
    
    lazy var loadingView: UIActivityIndicatorView! = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        view.hidesWhenStopped = true
        return view
    }()
    
    var isEmptyViewHidden: Bool = false {
        didSet {
            if isEmptyViewHidden {
                if tableView.backgroundView == emptyView {
                    tableView.backgroundView = nil
                }
                
            } else {
                emptyView.frame = tableView.bounds
                tableView.backgroundView = emptyView
            }
        }
    }
    
    var isLoadingViewHidden: Bool = false {
        didSet {
            if isLoadingViewHidden {
                loadingView.stopAnimating()
                if tableView.backgroundView == loadingView {
                    tableView.backgroundView = nil
                }
                
            } else {
                loadingView.frame = tableView.bounds
                loadingView.startAnimating()
                tableView.backgroundView = loadingView
            }
        }
    }
    
    var isRefreshingViewHidden: Bool = false {
        didSet {
            if refreshView.superview == nil {
                tableView.addSubview(refreshView)
            }
            
            if isRefreshingViewHidden {
                refreshView.endRefreshing()
                
            } else {
                refreshView.beginRefreshing()
            }
        }
    }
    
    var presenter: PostLikeModuleInterface!
    
    override func loadView() {
        super.loadView()
        
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        
        UserTableCell.register(in: tableView)
        
        setupNavigationItem()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
    
    func triggerRefresh() {
        presenter.refresh()
    }
    
    func setupNavigationItem() {
        let barItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back_nav_icon"), style: .plain, target: self, action: #selector(self.back))
        navigationItem.leftBarButtonItem = barItem
        
        navigationItem.title = "Likes"
    }
    
    func back() {
        presenter.exit()
    }
}

extension PostLikeViewController: PostLikeScene {
    
    var controller: UIViewController? {
        return self
    }
    
    func reload() {
        tableView.reloadData()
    }
    
    func reload(at index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func didRefresh(error: String?) {
        
    }
    
    func didLoadMore(error: String?) {
        
    }
    
    func didFollow(error: String?) {
        
    }
    
    func didUnfollow(error: String?) {
        
    }
}
