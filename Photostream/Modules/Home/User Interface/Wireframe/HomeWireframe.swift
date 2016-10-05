//
//  HomeWireframe.swift
//  Photostream
//
//  Created by Mounir Ybanez on 15/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class HomeWireframe: AnyObject {

    weak var homeViewController: HomeViewController!

    var rootWireframe: RootWireframe!

    init() {
        let sb = UIStoryboard(name: "HomeModuleStoryboard", bundle: nil)
        homeViewController = sb.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
    }

    func navigateHomeInterfaceFromWindow(_ window: UIWindow!) {
        configureNewsFeedModule()
        configureUserProfileModule()
        rootWireframe.showRootViewController(homeViewController, window: window)
    }

    fileprivate func configureNewsFeedModule() {
        let nav = homeViewController.viewControllers![0] as! UINavigationController
        let vc = nav.viewControllers[0] as! NewsFeedViewController
        let wireframe = NewsFeedWireframe()
        wireframe.newsFeedViewController = vc
        wireframe.rootWireframe = rootWireframe
        wireframe.newsFeedPresenter.view = vc
        vc.presenter = wireframe.newsFeedPresenter
    }

    fileprivate func configureUserProfileModule() {
        let nav = homeViewController.viewControllers![2] as! UINavigationController
        let vc = nav.viewControllers[0] as! UserProfileViewController
        let auth = AuthSession()
        let wireframe = UserProfileWireframe(userId: auth.user.id)
        wireframe.userProfileViewController = vc
        wireframe.rootWireframe = rootWireframe
        wireframe.userProfilePresenter.view = vc
        vc.presenter = wireframe.userProfilePresenter
        vc.preloadView()
    }
}
