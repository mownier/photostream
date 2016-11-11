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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.fetchPhotos()
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
    }
}
