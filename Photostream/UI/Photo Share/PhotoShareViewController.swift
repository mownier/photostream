//
//  PhotoShareViewController.swift
//  Photostream
//
//  Created by Mounir Ybanez on 18/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class PhotoShareViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var contentTextView: UITextView!

    var presenter: PhotoShareModuleInterface!
    var image: UIImage!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        imageView.image = image
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func didTapCancel(_ sender: AnyObject) {
        presenter.cancel()
        presenter.pop()
    }
    
    @IBAction func didTapDone(_ sender: AnyObject) {
        guard let message = contentTextView.text, !message.isEmpty else {
            return
        }
        
        presenter.finish(with: image, content:message)
        presenter.dismiss()
    }
}

extension PhotoShareViewController: PhotoShareViewInterface {
    
    var controller: UIViewController? {
        return self
    }
}


