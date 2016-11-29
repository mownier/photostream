//
//  CommentFeedData.swift
//  Photostream
//
//  Created by Mounir Ybanez on 29/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

protocol CommentFeedDataItemProtocol {
    
    var id: String { set get }
    var content: String { set get }
    var timestamp: Double { set get }
    var authorName: String { set get }
    var authorId: String { set get }
    var authorAvatar: String { set get }
}

struct CommentFeedDataItem: CommentFeedDataItemProtocol {
    
    var id: String = ""
    var content: String = ""
    var timestamp: Double = 0
    var authorName: String = ""
    var authorId: String = ""
    var authorAvatar: String = ""
}

extension Array where Element: CommentFeedDataItemProtocol {
    
    func indexOf(comment id: String) -> CommentFeedDataItemProtocol? {
        let index = self.index { item -> Bool in
            return item.id == id
        }
        
        guard index != nil else {
            return nil
        }
        
        return self[index!]
    }
}
