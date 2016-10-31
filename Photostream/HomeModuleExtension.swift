//
//  HomeModuleExtension.swift
//  Photostream
//
//  Created by Mounir Ybanez on 29/10/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

extension HomeWireframe {
    
    static var viewController: HomeViewController {
        let sb = UIStoryboard(name: "HomeModuleStoryboard", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "HomeViewController")
        return vc as! HomeViewController
    }
    
    
    func loadModuleDependency(with controller: UITabBarController) {
        let feedVC = (controller.viewControllers?[0] as? UINavigationController)?.topViewController as! NewsFeedViewController
        var feedWireframe = NewsFeedWireframe()
        feedWireframe.rootWireframe = root
        feedWireframe.newsFeedViewController = feedVC
        feedWireframe.newsFeedViewController.presenter = feedWireframe.newsFeedPresenter
        
        let profileVC = (controller.viewControllers?[2] as? UINavigationController)?.topViewController as! UserProfileViewController
        let profileWireframe = UserProfileWireframe(userId: nil)
        profileWireframe.rootWireframe = root
        profileWireframe.userProfileViewController = profileVC
        profileWireframe.userProfilePresenter.view = profileVC
        profileWireframe.userProfileViewController.presenter = profileWireframe.userProfilePresenter
    }
}
