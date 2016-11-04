//
//  HomeViewController.swift
//  Photostream
//
//  Created by Mounir Ybanez on 15/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class HomeViewController: UITabBarController {

    var presenter: HomePresenterInterface!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

extension HomeViewController: HomeViewInterface {
    
    var controller: UIViewController? {
        return self
    }
}
