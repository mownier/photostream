//
//  PostCellDisplayItemArray.swift
//  Photostream
//
//  Created by Mounir Ybanez on 29/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

public enum AppendMode: UInt {
    case `default` = 0
    case truncate = 1
}

public protocol PostCellDisplayItemProtocol {

    var postId: String { get set }
}

public struct PostCellDisplayItemArray<Element> {

    fileprivate var items: [Element]
    public var mode: AppendMode
    public var count: Int {
        return items.count
    }

    init() {
        items = [Element]()
        mode = .default
    }

    public mutating func append(_ item: Element) {
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

    public mutating func appendContentsOf(_ array: PostCellDisplayItemArray) {
        switch mode {

        case .default:
            self.items.append(contentsOf: array.items)

        case .truncate:
            self.items.removeAll()
            self.items.append(contentsOf: array.items)
        }
    }
}

extension PostCellDisplayItemArray where Element: PostCellDisplayItemProtocol {

    public subscript (postId: String) -> Int? {
        let index = items.index { (item) -> Bool in
            return item.postId == postId
        }
        return index
    }
}
