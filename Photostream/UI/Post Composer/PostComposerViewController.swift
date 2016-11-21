//
//  PostComposerViewController.swift
//  Photostream
//
//  Created by Mounir Ybanez on 09/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class PostComposerViewController: UIViewController {

    @IBOutlet weak var libraryButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    
    lazy var pages = [UIViewController]()
    
    var presenter: PostComposerModuleInterface!
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
        pageViewController?.setViewControllers([pages[0]] , direction: .forward, animated: false, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    @IBAction func didTapCancel(_ sender: AnyObject) {
        presenter.cancelWriting()
    }
    
    @IBAction func didTapNext(_ sender: AnyObject) {
        
    }
    
    @IBAction func didTapLibrary() {
        toggleLibraryButton()
        pageViewController?.setViewControllers([pages[0]], direction: .reverse, animated: true, completion: nil)
        title = "Photo Picker"
    }
    
    @IBAction func didTapCamera() {
        toggleCameraButton()
        pageViewController?.setViewControllers([pages[1]], direction: .forward, animated: true, completion: nil)
        title = "Photo Capture"
    }
    
    func toggleLibraryButton() {
        guard !libraryButton.isSelected else {
            return
        }
        
        libraryButton.isSelected = true
        cameraButton.isSelected = false
    }
    
    func toggleCameraButton() {
        guard !cameraButton.isSelected else {
            return
        }
        
        cameraButton.isSelected = true
        libraryButton.isSelected = false
    }
}

extension PostComposerViewController: PostComposerViewInterface {
    
    var controller: UIViewController? {
        return self
    }
    
    func setupDependency(with controllers: [UIViewController]) {
        pages.removeAll()
        pages.append(contentsOf: controllers)
    }
}

extension PostComposerViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.index(of: viewController), currentIndex < pages.count - 1 else {
            return nil
        }
        
        let nextIndex = currentIndex + 1
        return pages[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.index(of: viewController), currentIndex > 0 else {
            return nil
        }
        
        let previousIndex = currentIndex - 1
        return pages[previousIndex]
    }
}

extension PostComposerViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard previousViewControllers.count > 0, completed,
            let index = pages.index(of: previousViewControllers[0]) else {
            return
        }
        
        let nextIndex = index == 0 ? 1 : 0
        
        switch nextIndex {
        case 0:
            title = "Photo Picker"
            toggleLibraryButton()
        case 1:
            title = "Photo Capture"
            toggleCameraButton()
        default:
            break
        }
    }
}
