//
//  PostComposerViewController.swift
//  Photostream
//
//  Created by Mounir Ybanez on 09/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class PostComposerViewController: UIViewController {

    var presenter: PostComposerModuleInterface!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func didCancelWriting(_ sender: AnyObject) {
        presenter.cancelWriting()
    }
    
    @IBAction func didFinishWriting(_ sender: AnyObject) {
        presenter.doneWriting()
    }
}

extension PostComposerViewController: PostComposerViewInterface {
    
    var controller: UIViewController? {
        return self
    }
}
