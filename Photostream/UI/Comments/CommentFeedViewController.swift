//
//  CommentFeedViewController.swift
//  Photostream
//
//  Created by Mounir Ybanez on 23/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class CommentFeedViewController: UITableViewController {
    
    var presenter: CommentFeedModuleInterface!
    var indicatorView: UIActivityIndicatorView!
    var emptyView: UILabel!
    
    var shouldShowInitialLoadView: Bool = false {
        didSet {
            guard oldValue != shouldShowInitialLoadView else {
                return
            }
            
            if shouldShowInitialLoadView {
                tableView.backgroundView = indicatorView
                indicatorView.startAnimating()
            } else {
                indicatorView.stopAnimating()
                tableView.backgroundView = nil
            }
        }
    }
    
    var shouldShowEmptyView: Bool = false {
        didSet {
            guard oldValue != shouldShowEmptyView else {
                return
            }
            
            if shouldShowEmptyView {
                emptyView.frame = tableView.bounds
                tableView.backgroundView = emptyView
            } else {
                tableView.backgroundView = nil
            }
        }
    }
    
    override func loadView() {
        super.loadView()
        
        indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicatorView.hidesWhenStopped = true
        
        emptyView = UILabel()
        emptyView.text = "No comments"
        
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CommentCell")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.refreshComments()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.commentCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell")!
        let comment = presenter.comment(at: indexPath.row)
        cell.textLabel?.text = comment?.content
        return cell
    }
}

extension CommentFeedViewController: CommentFeedScene {
    
    var controller: UIViewController? {
        return self
    }
    
    func reload() {
        tableView.reloadData()
    }
    
    func showEmptyView() {
        shouldShowEmptyView = true
    }
    
    func showInitialLoadView() {
        shouldShowInitialLoadView = true
    }
    
    func didRefreshComments(with error: String?) {
        shouldShowInitialLoadView = false
        shouldShowEmptyView = false
    }
    
    func didLoadMoreComments(with error: String?) {
        
    }
}
