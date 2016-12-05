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
    
    var commentWriterView: CommentWriterView! {
        return view as! CommentWriterView
    }
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.addKeyboardObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        presenter.removeKeyboardObserver()
    }
}

extension CommentWriterViewController: CommentWriterScene {
    
    var controller: UIViewController? {
        return self
    }
    
    func didWrite(with error: String?) {
        commentWriterView.isSending = false
    }
    
    func keyboardWillMove(with handler: inout KeyboardHandler) {
        handler.handle(using: view)
    }
}

extension CommentWriterViewController: CommentWriterViewDelegate {
    
    func willSend(with content: String?, view: CommentWriterView) {
        guard let comment = content?.trimmingCharacters(in: .whitespacesAndNewlines),
            !comment.isEmpty else {
            didWrite(with: "Comment is emtpy")
            return
        }
        
        presenter.writeComment(with: comment)
    }
}
