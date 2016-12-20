//
//  HomeViewController.swift
//  Photostream
//
//  Created by Mounir Ybanez on 15/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class HomeViewController: UITabBarController {

    lazy var specialButton = UIButton()
    
    var specialIndex: Int? {
        didSet {
            guard let index = specialIndex else {
                specialButton.removeFromSuperview()
                return
            }
            
            guard tabBar.subviews.isValid(index) else {
                return
            }
            
            if specialButton.superview == nil {
                specialButton.backgroundColor = UIColor.clear
                specialButton.addTarget(self, action: #selector(self.showPostComposer), for: .touchUpInside)
                view.addSubview(specialButton)
            }
            
            let tabBarButtons = tabBar.subviews.filter { subview -> Bool in
                return subview.isUserInteractionEnabled
            }
            
            let subviews = tabBarButtons.sorted { (button1, button2) -> Bool in
                return button1.frame.origin.x < button2.frame.origin.x
            }
            
            let subview = subviews[index]
            let point = subview.superview!.convert(subview.frame.origin, to: view)
            let size = subview.frame.size
            let frame = CGRect(origin: point, size: size)
            specialButton.frame = frame
            
            view.bringSubview(toFront: specialButton)
        }
    }
    
    var presenter: HomePresenterInterface!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        specialIndex = 2
    }
    
    func showPostComposer() {
        presenter.presentPostComposer()
    }
}

extension HomeViewController: HomeViewInterface {
    
    var controller: UIViewController? {
        return self
    }
}
