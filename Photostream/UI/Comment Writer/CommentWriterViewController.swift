//
//  CommentWriterViewController.swift
//  Photostream
//
//  Created by Mounir Ybanez on 30/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class CommentWriterViewController: UIViewController {

    var presenter: CommentWriterModuleInterface!
    
    override func loadView() {
        super.loadView()
        
        view.frame.size.height = 64
    }
    
    override func didMove(toParentViewController parent: UIViewController?) {
        guard parent != nil else {
            return
        }
        
        view.frame.origin.y = parent!.view.frame.size.height - 64
    }
}

extension CommentWriterViewController: CommentWriterScene {
    
    var controller: UIViewController? {
        return self
    }
    
    func didWrite(with error: String?) {
        
    }
}
