//
//  PostUploadViewController.swift
//  Photostream
//
//  Created by Mounir Ybanez on 23/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class PostUploadViewController: UIViewController {
    
    var presenter: PostUploadModuleInterface!
    var uploadView: PostUploadView! {
        return view as! PostUploadView
    }
    
    override func loadView() {
        let width: CGFloat = UIScreen.main.bounds.size.width
        let height: CGFloat = 44 + (4 * 2)
        let size = CGSize(width: width, height: height)
        let frame = CGRect(origin: .zero, size: size)
            
        preferredContentSize = size
        view = PostUploadView(frame: frame)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.willShowImage()
        presenter.upload()
    }
}

extension PostUploadViewController: PostUploadViewInterface {
    
    var controller: UIViewController? {
        return self
    }
    
    func show(image: UIImage) {
        uploadView.imageView.image = image
    }
    
    func didSucceed() {
        presenter.detach()
    }
    
    func didFail(with message: String) {
        print("Post Upload View Controller: did fail ==>", message)
    }
    
    func didUpdate(with progress: Progress) {
        let percentage = Float(progress.fractionCompleted)
        uploadView.progressView.setProgress(percentage, animated: true)
    }
}
