//
//  PostGridCellDataSource.swift
//  Photostream
//
//  Created by Mounir Ybanez on 29/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

public class PostGridCellDataSource: NSObject, PostCellLoaderDataSourceProtocol {
    
    private var items: PostGridCellItemArray
    
    init(items: PostGridCellItemArray) {
        self.items = items
    }
    
    public func appendContentsOf(array: PostGridCellItemArray) {
        items.appendContentsOf(array)
    }
    
    public subscript(index: Int) -> PostCellDisplayItemProtocol? {
        set {
            if let val = newValue as? PostGridCellItem {
                items[index] = val
            }
        }
        get {
            return items[index]
        }
    }
    
    public subscript(postId: String) -> (Int, PostCellDisplayItemProtocol)? {
        if let index = items[postId] {
           return (index, items[index]!)
        }
        return nil
    }
}

extension PostGridCellDataSource: UICollectionViewDataSource {
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kPostGridCellReuseId, forIndexPath: indexPath) as! PostGridCell
        if let item = items[indexPath.row] {
            configureCell(cell, item: item)
        }
        return cell
    }
}

extension PostGridCellDataSource: PostGridCellConfiguration {
    
    public func configureCell(cell: PostGridCell, item: PostGridCellItem) {
        cell.setPhotoUrl(item.photoUrl, placeholderImage: nil)
    }
}
