//
//  PostCellDisplayItemArray.swift
//  Photostream
//
//  Created by Mounir Ybanez on 29/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

public enum AppendMode: UInt {
    case Default = 0
    case Truncate = 1
}

public protocol PostCellDisplayItemProtocol {
    
    var postId: String { get set }
}

public struct PostCellDisplayItemArray<Element> {
    
    private var items: [Element]
    public var mode: AppendMode
    public var count: Int {
        return items.count
    }
    
    init() {
        items = [Element]()
        mode = .Default
    }
    
    public mutating func append(item: Element) {
        items.append(item)
    }
    
    public subscript (index: Int) -> Element? {
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
    
    public mutating func appendContentsOf(array: PostCellDisplayItemArray) {
        switch mode {
            
        case .Default:
            self.items.appendContentsOf(array.items)
            
        case .Truncate:
            self.items.removeAll()
            self.items.appendContentsOf(array.items)
        }
    }
}

extension PostCellDisplayItemArray where Element: PostCellDisplayItemProtocol {
    
    public subscript (postId: String) -> Int? {
        let index = items.indexOf { (item) -> Bool in
            return item.postId == postId
        }
        return index
    }
}
