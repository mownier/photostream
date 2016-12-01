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
        
        let customView = CommentWriterView()
        customView.delegate = self
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

extension CommentWriterViewController: CommentWriterViewDelegate {
    
    func willSend(with content: String?, view: CommentWriterView) {
        
    }
}
