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
        let width: CGFloat = UIScreen.main.bounds.size.width
        let height: CGFloat = 44
        let size = CGSize(width: width, height: height)
        
        let customView = UIView()
        customView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        customView.frame.size = size
        
        preferredContentSize = size
        view = customView
    }
}

extension CommentWriterViewController: CommentWriterScene {
    
    var controller: UIViewController? {
        return self
    }
    
    func didWrite(with error: String?) {
        
    }
}
