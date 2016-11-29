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

extension CommentFeedDataItem: CommentListCellItem {
    
    var timeAgo: String {
        let date = NSDate(timeIntervalSinceNow: timestamp)
        return date.timeAgoSinceNow()
    }
}
