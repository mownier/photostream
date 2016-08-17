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
    }

    func navigateHomeInterfaceFromWindow(window: UIWindow!) {
        let sb = UIStoryboard(name: "HomeModuleStoryboard", bundle: nil)
        homeViewController = sb.instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
        
        let nav = homeViewController.viewControllers?[0] as! UINavigationController
        let vc = nav.viewControllers[0] as! NewsFeedViewController
        let newsFeedWireframe = NewsFeedWireframe()
        newsFeedWireframe.newsFeedPresenter.view = vc
        vc.presenter = newsFeedWireframe.newsFeedPresenter
        
        rootWireframe.showRootViewController(homeViewController, window: window)
    }
}
