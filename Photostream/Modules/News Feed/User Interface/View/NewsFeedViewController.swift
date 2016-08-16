//
//  NewsFeedViewController.swift
//  Photostream
//
//  Created by Mounir Ybanez on 16/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit
import MONUniformFlowLayout

class NewsFeedViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: MONUniformFlowLayout!

    override func viewDidLoad() {
        super.viewDidLoad()

        addCustomTitleView()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        flowLayout.enableStickyHeader = true
        collectionView.contentOffset = CGPoint(x: 0, y: 0)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    private func addCustomTitleView() {
        let titleView = UILabel(frame: CGRect.zero)
        let fontDesc = UIFontDescriptor(name: "Snell Roundhand", size: 24).fontDescriptorWithSymbolicTraits(.TraitBold)
        titleView.font = UIFont(descriptor: fontDesc, size: fontDesc.pointSize)
        titleView.text = "Photostream"
        titleView.sizeToFit()
        navigationItem.titleView = titleView
    }
}

extension NewsFeedViewController: MONUniformFlowLayoutDelegate {

    func collectionView(collectionView: UICollectionView!, layout: MONUniformFlowLayout!, itemHeightInSection section: Int) -> CGFloat {
        return 100.0
    }

    func collectionView(collectionView: UICollectionView!, layout: MONUniformFlowLayout!, headerHeightInSection section: Int) -> CGFloat {
        return 60
    }
}

extension NewsFeedViewController: UICollectionViewDelegate {

}


extension NewsFeedViewController: UICollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 10
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("NewsFeedCell", forIndexPath: indexPath)
        cell.backgroundColor = UIColor.greenColor()
        return cell
    }

    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {

        var reuseId: String!
        if kind == UICollectionElementKindSectionHeader {
            reuseId = "NewsFeedHeaderView"
        } else {
            reuseId = "NewsFeedFooterView"
        }

        let reusableView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: reuseId, forIndexPath: indexPath)

        if reuseId == "NewsFeedHeaderView" {
            let headerView = reusableView as! NewsFeedHeaderView
            headerView.setDisplayName("Wowowee")
        }

        return reusableView
    }
}

extension UICollectionView {

    func headerHeightInSection(section: Int) -> CGFloat {
        let del = delegate as! MONUniformFlowLayoutDelegate
        let layout = collectionViewLayout as! MONUniformFlowLayout
        return del.collectionView!(self, layout: layout, headerHeightInSection: section)
    }
}
