//
//  CommentWriterModuleExtension.swift
//  Photostream
//
//  Created by Mounir Ybanez on 30/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

extension CommentWriterModule {
    
    convenience init() {
        self.init(view: CommentWriterViewController())
    }
}

extension CommentWriterDataItem: CommentFeedData { }

extension CommentWriterDataItem: CommentListCellItem { }

extension CommentWriterScene {
    
    func becomeFirstResponder() {
        guard let view = controller?.view as? CommentWriterView else {
            return
        }
        
        view.contentTextView.becomeFirstResponder()
    }
}
