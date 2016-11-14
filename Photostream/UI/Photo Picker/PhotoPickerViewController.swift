//
//  PhotoPickerViewController.swift
//  Photostream
//
//  Created by Mounir Ybanez on 11/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit
import Photos

class PhotoPickerViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var presenter: PhotoPickerModuleInterface!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        collectionView.contentInset.top = scrollView.height
        collectionView.scrollIndicatorInsets.top = scrollView.height
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
        
        if presenter.photoCount > 0 {
            let asset = presenter.photo(at: 0)!
            showSelectedPhoto(with: asset)
        }
    }
    
    var targetSize: CGSize {
        let scale = UIScreen.main.scale
        return CGSize(width: scrollView.bounds.width * scale,
                      height: scrollView.bounds.height * scale)
    }
}

extension PhotoPickerViewController {
    
    func showSelectedPhoto(with asset: PHAsset) {
        scrollView.removeAllSubviews()
        PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: nil, resultHandler: { image, _ in
            guard let image = image else { return }
            
            let imageRect = CGRect(origin: .zero, size: image.size)
            var fitRect = imageRect.fit(in: self.scrollView.bounds)
            fitRect.ceil()
            
            let imageView = UIImageView()
            imageView.frame = fitRect
            imageView.image = image
            self.scrollView.addSubview(imageView)
        })
    }
}
