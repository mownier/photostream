//
//  NewsFeedData.swift
//  Photostream
//
//  Created by Mounir Ybanez on 20/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

protocol NewsFeedDataItem {}

struct NewsFeedData {
    
    var items: [NewsFeedDataItem]
    
    init() {
        self.items = [NewsFeedDataItem]()
    }
    
    subscript(id: String) -> NewsFeedPost? {
        set {
            guard let index = indexOf(post: id),
                let value = newValue else {
                    return
            }
            
            items[index] = value
        }
        get {
            guard let index = indexOf(post: id) else {
                return nil
            }
            
            return items[index] as? NewsFeedPost
        }
    }
    
    func indexOf(post id: String) -> Int? {
        let index = items.index { (item) -> Bool in
            if let post = item as? NewsFeedPost {
                return post.id == id
            }
            return false
        }
        return index
    }
}

struct NewsFeedPost: NewsFeedDataItem {
    
    var id: String = ""
    var message: String = ""
    var timestamp: Double = 0
    
    var photoUrl: String = ""
    var photoWidth: Int = 0
    var photoHeight: Int = 0
    
    var likes: Int = 0
    var comments: Int = 0
    var isLiked: Bool = false
    
    var userId: String = ""
    var avatarUrl: String = ""
    var displayName: String = ""
}

struct NewsFeedAd: NewsFeedDataItem {}
