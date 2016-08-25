//
//  PostCellItemList.swift
//  Photostream
//
//  Created by Mounir Ybanez on 25/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

public enum AppendMode: UInt {
    case Default = 0
    case Truncate = 1
}

public struct PostCellItemList {
    
    private var items: [PostCellItem]
    public var mode: AppendMode
    public var count: Int {
        return items.count
    }
    
    init() {
        items = [PostCellItem]()
        mode = .Default
    }
    
    public mutating func append(item: PostCellItem) {
        items.append(item)
    }
    
    public subscript (index: Int) -> PostCellItem? {
        set {
            if let val = newValue {
                items[index] = val
            }
        }
        get {
            if items.isValid(index) {
                return items[index]
            }
            return nil
        }
    }
    
    public subscript (postId: String) -> Int? {
        let index = items.indexOf { (item) -> Bool in
            return item.postId == postId
        }
        return index
    }
    
    public mutating func appendContentsOf(list: PostCellItemList) {
        switch mode {
            
        case .Default:
            self.items.appendContentsOf(list.items)
            
        case .Truncate:
            self.items.removeAll()
            self.items.appendContentsOf(list.items)
        }
    }
}
