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
    @IBOutlet weak var cropView: CropView!
    
    var presenter: PhotoPickerModuleInterface!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        collectionView.contentInset.top = cropView.height
        collectionView.scrollIndicatorInsets.top = cropView.height
        flowLayout.configure(with: collectionView.width, columnCount: 4)
        
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
            presenter.willShowSelectedPhoto(at: 0, size: targetSize)
        }
    }
    
    func showSelectedPhoto(with image: UIImage?) {
        cropView.setCropTarget(with: image)
        cropView.zoomToFit(false)
    }
}

extension PhotoPickerViewController {
    
    var targetSize: CGSize {
        let scale = UIScreen.main.scale
        return CGSize(width: cropView.bounds.width * scale,
                      height: cropView.bounds.height * scale)
    }
}
