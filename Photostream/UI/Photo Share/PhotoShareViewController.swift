//
//  PhotoShareViewController.swift
//  Photostream
//
//  Created by Mounir Ybanez on 18/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class PhotoShareViewController: UIViewController {

    var presenter: PhotoShareModuleInterface!
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func didTapCancel(_ sender: AnyObject) {
        presenter.pop()
    }
    
    @IBAction func didTapDone(_ sender: AnyObject) {
        
    }
}

extension PhotoShareViewController: PhotoShareViewInterface {
    
    var controller: UIViewController? {
        return self
    }
    
    
}
