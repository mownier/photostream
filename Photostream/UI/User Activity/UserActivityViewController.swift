//
//  UserActivityViewController.swift
//  Photostream
//
//  Created by Mounir Ybanez on 23/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class UserActivityViewController: UITableViewController {

    var presenter: UserActivityModuleInterface!
    
    lazy var likeCellPrototype = ActivityTableLikeCell()
    lazy var commentCellPrototype = ActivityTableCommentCell()
    lazy var followCellPrototype = ActivityTableFollowCell()
    lazy var postCellPrototype = ActivityTablePostCell()
    
    lazy var emptyView: GhostView! = {
        let view = GhostView()
        view.titleLabel.text = "No activities"
        return view
    }()
    
    lazy var loadingView: UIActivityIndicatorView! = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        view.hidesWhenStopped = true
        return view
    }()
    
    lazy var refreshView: UIRefreshControl! = {
        let view = UIRefreshControl()
        view.addTarget(
            self,
            action: #selector(self.triggerRefresh),
            for: .valueChanged)
        return view
    }()
    
    var shouldShowLoadingView: Bool = false {
        didSet {
            guard shouldShowLoadingView != oldValue else {
                return
            }
            
            if shouldShowLoadingView {
                loadingView.startAnimating()
                tableView.backgroundView = loadingView
            } else {
                loadingView.stopAnimating()
                loadingView.removeFromSuperview()
                tableView.backgroundView = nil
            }
        }
    }
    
    var shouldShowRefreshView: Bool = false {
        didSet {
            if refreshView.superview == nil {
                tableView.addSubview(refreshView)
            }
            
            if shouldShowLoadingView {
                refreshView.beginRefreshing()
            } else {
                refreshView.endRefreshing()
            }
        }
    }
    
    var shouldShowEmptyView: Bool = false {
        didSet {
            guard shouldShowEmptyView != oldValue else {
                return
            }
            
            if shouldShowEmptyView {
                emptyView.frame.size = tableView.frame.size
                tableView.backgroundView = emptyView
            } else {
                tableView.backgroundView = nil
                emptyView.removeFromSuperview()
            }
        }
    }
    
    override func loadView() {
        super.loadView()
        
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        
        ActivityTableLikeCell.register(in: tableView)
        ActivityTableCommentCell.register(in: tableView)
        ActivityTableFollowCell.register(in: tableView)
        ActivityTablePostCell.register(in: tableView)
        
        likeCellPrototype.frame.size.width = tableView.bounds.width
        commentCellPrototype.frame.size.width = tableView.bounds.width
        followCellPrototype.frame.size.width = tableView.bounds.width
        postCellPrototype.frame.size.width = tableView.bounds.width
        
        navigationItem.title = "Activity"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
    
    func triggerRefresh() {
        presenter.refreshActivities()
    }
}

extension UserActivityViewController: UserActivityScene {
    
    var controller: UIViewController? {
        return self
    }
    
    func reloadView() {
        tableView.reloadData()
    }
    
    func showEmptyView() {
        shouldShowEmptyView = true
    }
    
    func showRefreshView() {
        shouldShowRefreshView = true
    }
    
    func showInitialLoadView() {
        shouldShowLoadingView = true
    }
    
    func hideEmptyView() {
        shouldShowEmptyView = false
    }
    
    func hideRefreshView() {
        shouldShowRefreshView = false
    }
    
    func hideInitialLoadView() {
        shouldShowLoadingView = false
    }
    
    func didRefresh(with error: String?) {
        
    }
    
    func didLoadMore(with error: String?) {
        
    }
}
