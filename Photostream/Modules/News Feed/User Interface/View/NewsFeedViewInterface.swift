//
//  NewsFeedViewInterface.swift
//  Photostream
//
//  Created by Mounir Ybanez on 17/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

protocol NewsFeedViewInterface: NSObjectProtocol {

    var controller: UIViewController? { get }
    var presenter: NewsFeedPresenterInterface! { set get }
    
    func reloadView()
    func showEmptyView()
    func didRefreshFeeds()
    func didLoadMoreFeeds()
    func didFetchWithError(message: String)
    func didLike()
    func didUnlike()
    func didFailToLikeWithError(message: String)
    func didFailToUnlikeWithError(message: String)
}
