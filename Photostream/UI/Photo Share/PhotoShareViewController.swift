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
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
 
        // Upload photo
        let session = AuthSession()
        let service = FileServiceProvider(session: session)
        var uploadData = FileServiceImageUploadData()
        uploadData.data = UIImageJPEGRepresentation(image, 1.0)!
        uploadData.width = Float(image.size.width)
        uploadData.height = Float(image.size.height)
        let uploadView = PhotoUploadView()
        uploadView.frame = CGRect(x: 0, y: 0, width: view.width, height: 44 + (4 * 2))
        view.addSubview(uploadView)
        uploadView.imageView.image = image
        service.uploadJPEGImage(data: uploadData, track: { (progress) in
            guard let fractionCompletd = progress?.fractionCompleted else {
                return
            }
            
            uploadView.progressView.setProgress(Float(fractionCompletd), animated: true)
        }) { (result) in
            print(result)
        }
    }
}

extension PhotoShareViewController: PhotoShareViewInterface {
    
    var controller: UIViewController? {
        return self
    }
}

class PhotoUploadView: UIView {
    
    fileprivate let uniformLength: CGFloat = 44
    fileprivate let uniformSpacing: CGFloat = 4
    fileprivate var fixHeight: CGFloat {
        return uniformSpacing + (uniformLength * 2)
    }
    
    var imageView: UIImageView!
    var progressView: UIProgressView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
        initSetup()
    }
    
    deinit {
        removeFrameObserver()
    }
    
    override func layoutSubviews() {
        var rect = CGRect(x: uniformSpacing, y: uniformSpacing, width: uniformLength, height: uniformLength)
        imageView.frame = rect
        
        rect = progressView.frame
        rect.origin.x = uniformLength + (uniformSpacing * 2)
        rect.origin.y = imageView.center.y
        rect.size.width = frame.size.width - (uniformLength + (uniformSpacing * 3))
        progressView.frame = rect
    }
    
    func initSetup() {
        addFrameObserver()
        
        backgroundColor = UIColor.white
        
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.lightGray
        
        progressView = UIProgressView()
        progressView.tintColor = UIColor(red: 10/255, green: 10/255, blue: 10/255, alpha: 1.0)
        
        addSubview(imageView)
        addSubview(progressView)
    }
}

extension PhotoUploadView {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let rect = change?[.newKey] as? CGRect,
            rect.size.height != fixHeight else {
            return
        }
        
        didUpdateFrame {
            frame.size.height = fixHeight
        }
    }
    
    func addFrameObserver() {
        addObserver(self, forKeyPath: "frame", options: .new, context: nil)
    }
    
    func removeFrameObserver() {
        removeObserver(self, forKeyPath: "frame")
    }
    
    func didUpdateFrame(handler:() -> Void) {
        removeFrameObserver()
        handler()
        addFrameObserver()
    }
}
