//
//  NewsFeedViewInterface.swift
//  Photostream
//
//  Created by Mounir Ybanez on 17/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

protocol NewsFeedViewInterface: class {

    var controller: UIViewController? { get }
    var presenter: NewsFeedModuleInterface! { set get }
    
    func reloadView()
    func showEmptyView()
    func didRefreshFeeds()
    func didLoadMoreFeeds()
    func didFetchWithError(message: String)
    func didLikeWithError(message: String?)
    func didUnlikeWithError(message: String?)
}
