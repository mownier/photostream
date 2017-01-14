//
//  PhotoLibraryViewController.swift
//  Photostream
//
//  Created by Mounir Ybanez on 11/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit
import Photos

enum PhotoLibraryViewControllerStyle {
    
    case style1, style2
}

class PhotoLibraryViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var cropView: CropView!
    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var cropContentViewConstraintTop: NSLayoutConstraint!
    @IBOutlet weak var contentModeToggleButton: UIButton!
    
    lazy var scrollHandler = ScrollHandler()
    
    var presenter: PhotoLibraryModuleInterface!
    var selectedIndex: Int = -1
    var style: PhotoLibraryViewControllerStyle = .style1
    
    override func loadView() {
        super.loadView()
        
        presenter.set(photoCropper: cropView)
        scrollHandler.scrollView = collectionView
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTapDimView))
        dimView.addGestureRecognizer(tap)
        
        switch style {
        
        case .style2:
            cropView.cornerRadius = view.frame.width / 2
            contentModeToggleButton.isHidden = true
            
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard selectedIndex < 0 else {
            return
        }
        
        collectionView.contentInset.top = view.width + 2
        collectionView.scrollIndicatorInsets.top = view.width + 2
        flowLayout.configure(with: view.width, columnCount: 4, columnSpacing: 0.5, rowSpacing: 2)
        
        presenter.fetchPhotos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addObserver(self, forKeyPath: "cropContentViewConstraintTop.constant", options: .new, context: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeObserver(self, forKeyPath: "cropContentViewConstraintTop.constant")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let newValue = change?[.newKey] as? CGFloat else {
            return
        }
        
        dimView.isHidden = newValue == 0
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    @IBAction func didTapDone(_ sender: AnyObject) {
        presenter.done()
        presenter.dismiss()
    }
    
    @IBAction func didTapCancel(_ sender: AnyObject) {
        presenter.cancel()
        presenter.dismiss()
    }
    
    @IBAction func toggleContentMode() {
        presenter.toggleContentMode(animated: true)
    }
    
    func didTapDimView() {
        scrollHandler.killScroll()
        UIView.animate(withDuration: 0.25) { 
            self.cropContentViewConstraintTop.constant = 0
            self.dimView.alpha = 0
            
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }
}

extension PhotoLibraryViewController: PhotoLibraryViewInterface {
    
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
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
        }
    }
    
    func showSelectedPhoto(with image: UIImage?) {
        switch style {
            
        case .style1:
            cropView.setCropTarget(with: image, content: .fit)
            presenter.fillSelectedPhoto(animated: false)
            
        case .style2:
            cropView.setCropTarget(with: image, content: .fill)
        }
    }
    
    func showSelectedPhotoInFitMode(animated: Bool) {
        cropView.zoomToFit(animated)
    }
    
    func showSelectedPhotoInFillMode(animated: Bool) {
        cropView.zoomToFill(animated)
    }
}
