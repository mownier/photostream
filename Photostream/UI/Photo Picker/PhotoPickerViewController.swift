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
    @IBOutlet weak var cropContentViewConstraintTop: NSLayoutConstraint!
    
    var presenter: PhotoPickerModuleInterface!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        collectionView.contentInset.top = cropView.height + 2
        collectionView.scrollIndicatorInsets.top = cropView.height + 2
        flowLayout.configure(with: collectionView.width, columnCount: 4, columnSpacing: 0.5, rowSpacing: 2)
        
        presenter.fetchPhotos()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    @IBAction func didTapDone(_ sender: AnyObject) {
        presenter.didCrop(with: cropView.croppedImage)
    }
    
    @IBAction func didTapCancel(_ sender: AnyObject) {
        presenter.didCancelCrop()
    }
    
    @IBAction func toggleContentMode() {
        presenter.toggleContentMode(animated: true)
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
            let indexPath = IndexPath(row: 0, section: 0)
            collectionView(collectionView, didSelectItemAt: indexPath)
        }
    }
    
    func showSelectedPhoto(with image: UIImage?) {
        cropView.setCropTarget(with: image)
        presenter.fillSelectedPhoto(animated: false)
    }
    
    func showSelectedPhotoInFitMode(animated: Bool) {
        cropView.zoomToFit(animated)
    }
    
    func showSelectedPhotoInFillMode(animated: Bool) {
        cropView.zoomToFill(animated)
    }
}


