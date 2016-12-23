//
//  UserActivityModuleExtension.swift
//  Photostream
//
//  Created by Mounir Ybanez on 23/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

extension UserActivityLikeDataItem: ActivityTableCellLikeItem {
    
    var content: String {
        return "\(displayName) liked your photo."
    }
}

extension UserActivityPostDataItem: ActivityTableCellPostItem {
    
    var content: String {
        return "\(displayName) shared a photo."
    }
}

extension UserActivityCommentDataItem: ActivityTableCellCommentItem {
    
    var content: String {
        return "\(displayName) commented \"\(message)\" in your photo."
    }
}

extension UserActivityFollowDataItem: ActivityTableCellFollowItem {
    
    var content: String {
        return "\(displayName) started following you."
    }
}

