//
//  SinglePostData.swift
//  Photostream
//
//  Created by Mounir Ybanez on 18/01/2017.
//  Copyright © 2017 Mounir Ybanez. All rights reserved.
//

protocol SinglePostData {

    var id: String { set get }
    var message: String { set get }
    var timestamp: Double { set get }
    
    var photoUrl: String { set get }
    var photoWidth: Int { set get }
    var photoHeight: Int { set get }
    
    var likes: Int { set get }
    var comments: Int { set get }
    var isLiked: Bool { set get }
    
    var userId: String { set get }
    var avatarUrl: String { set get }
    var displayName: String { set get }
}

struct SinglePostDataItem: SinglePostData {
    
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
