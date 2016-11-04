//
//  PostListFooter.swift
//  Photostream
//
//  Created by Mounir Ybanez on 01/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

let kPostListFooterViewReuseId = "PostFooterView"

class PostListFooter: UICollectionReusableView {

}

extension PostListFooter {
    
    class func dequeue(from view: UICollectionView, at indexPath: IndexPath) -> PostListFooter? {
        let kind = UICollectionElementKindSectionFooter
        let footer = view.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kPostListFooterViewReuseId, for: indexPath)
        return footer as? PostListFooter
    }
    
    class func registerClass(in view: UICollectionView) {
        let viewClass = PostListFooter.self
        let kind = UICollectionElementKindSectionFooter
        view.register(viewClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: kPostListFooterViewReuseId)
    }
}
