//
//  PhotoPickerViewController.swift
//  Photostream
//
//  Created by Mounir Ybanez on 09/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class PhotoPickerViewController: UIViewController {
    
    @IBOutlet weak var libraryButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    
    lazy var pages = [UIViewController]()
    
    var presenter: PhotoPickerModuleInterface!
    var pageViewController: UIPageViewController? {
        guard !childViewControllers.isEmpty else {
            return nil
        }
        
        let vc = childViewControllers[0] as? UIPageViewController
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageViewController?.dataSource = self
        pageViewController?.delegate = self
        
        presenter.willShowLibrary()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    @IBAction func didTapCancel(_ sender: AnyObject) {
        presenter.cancel()
        presenter.dismiss()
    }
    
    @IBAction func didTapNext(_ sender: AnyObject) {
        presenter.didPickPhotoFromLibrary()
    }
    
    @IBAction func didTapLibrary() {
        presenter.willShowLibrary()
    }
    
    @IBAction func didTapCamera() {
        presenter.willShowCamera()
    }
}

extension PhotoPickerViewController: PhotoPickerViewInterface {
    
    var controller: UIViewController? {
        return self
    }
    
    func setupDependency(with controllers: [UIViewController]) {
        pages.removeAll()
        pages.append(contentsOf: controllers)
    }
    
    func showLibrary() {
        libraryButton.isSelected = true
        cameraButton.isSelected = false
        title = "Photo Library"
        
        let rightBarItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(self.didTapNext(_:)))
        navigationItem.rightBarButtonItem = rightBarItem
                    
        pageViewController?.setViewControllers([pages[0]], direction: .reverse, animated: true, completion: nil)
    }
    
    func showCamera() {
        libraryButton.isSelected = false
        cameraButton.isSelected = true
        title = "Photo Capture"
        
        navigationItem.rightBarButtonItem = nil
        
        pageViewController?.setViewControllers([pages[1]], direction: .forward, animated: true, completion: nil)
    }
}
