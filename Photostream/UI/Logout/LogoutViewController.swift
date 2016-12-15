//
//  LogoutViewController.swift
//  Photostream
//
//  Created by Mounir Ybanez on 15/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class LogoutViewController: UIAlertController {
    
    var presenter: LogoutModuleInterface!
    
    override func loadView() {
        super.loadView()
        
        var action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        addAction(action)
        
        action = UIAlertAction(title: "OK", style: .default) { (action) in
            self.presenter.logout()
        }
        
        addAction(action)
    }
}

extension LogoutViewController: LogoutScene {
    
    var controller: UIViewController? {
        return self
    }
    
    func didLogout(with error: String?) {
        guard error == nil else {
            presenter.exit()
            return
        }
        
        presenter.presentLogin()
    }
}
