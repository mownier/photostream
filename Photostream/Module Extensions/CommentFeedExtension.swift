//
//  CommentFeedExtension.swift
//  Photostream
//
//  Created by Mounir Ybanez on 29/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import DateTools

extension CommentFeedModule {
    
    convenience init() {
        self.init(view: CommentFeedViewController())
    }
}

extension CommentFeedDataItem: CommentListCellItem { }

extension CommentFeedScene {
    
    func adjust(bottomInset: CGFloat) {
        guard let view = controller?.view as? UITableView else {
            return
        }
        
        view.scrollIndicatorInsets.bottom += bottomInset
        view.contentInset.bottom += bottomInset
    }
    
    func scrollToTop(animated: Bool = false) {
        guard let view = controller?.view as? UITableView else {
            return
        }
        
        let indexPath = IndexPath(row: 0, section: 0)
        view.scrollToRow(at: indexPath, at: .top, animated: animated)
    }
}
