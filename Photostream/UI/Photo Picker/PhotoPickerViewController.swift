//
//  PhotoPickerViewController.swift
//  Photostream
//
//  Created by Mounir Ybanez on 11/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class PhotoPickerViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var presenter: PhotoPickerModuleInterface!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        configureLayout(with: 3, columnSpacing: 1, rowSpacing: 1)
        presenter.fetchPhotos()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    @IBAction func didTapDone(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapCancel(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    func configureLayout(with columnCount: Int, columnSpacing: CGFloat, rowSpacing: CGFloat) {
        let totalColumnSpacing = (columnSpacing / 2) * CGFloat((columnCount - 1))
        let side = (collectionView.width / CGFloat(columnCount)) - totalColumnSpacing
        flowLayout.itemSize = CGSize(width: side, height: side)
        flowLayout.minimumInteritemSpacing = (columnSpacing / 2)
        flowLayout.minimumLineSpacing = rowSpacing
    }
}

extension PhotoPickerViewController: PhotoPickerViewInterface {
    
    var controller: UIViewController? {
        return self
    }
    
    func reloadView() {
        collectionView.reloadData()
    }
    
    func didFetchPhotos() {
        reloadView()
    }
}
