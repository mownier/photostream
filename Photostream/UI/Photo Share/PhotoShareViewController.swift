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
        presenter.dismiss()
    }
}

extension PhotoShareViewController: PhotoShareViewInterface {
    
    var controller: UIViewController? {
        return self
    }
    
    func upload() {
        let content = contentTextView.text!
        
        var data = FileServiceImageUploadData()
        data.data = UIImageJPEGRepresentation(image, 1.0)!
        data.width = Float(image.size.width)
        data.height = Float(image.size.height)
        
        let uploadView = PhotoUploadView()
        uploadView.frame = CGRect(x: 0, y: 0, width: view.width, height: 44 + (4 * 2))
        view.addSubview(uploadView)
        uploadView.imageView.image = image
        
        let auth = AuthSession()
        let fileService = FileServiceProvider(session: auth)
        let postService = PostServiceProvider(session: auth)
        
        // Upload first the photo
        fileService.uploadJPEGImage(data: data, track: { (progress) in
            guard progress != nil else {
                return
            }
            
            let value = Float(progress!.fractionCompleted)
            uploadView.progressView.setProgress(value, animated: true)
            
        }) { (result) in
            guard let fileId = result.fileId, result.error == nil else {
                self.didFail(with: result.error!.message)
                return
            }
            
            // Write details of the post
            postService.writePost(photoId: fileId, content: content, callback: { (result) in
                guard result.error == nil else {
                    self.didFail(with: result.error!.message)
                    return
                }
                
                guard let posts = result.posts,
                    posts.count > 0,
                    let (post, user) = posts[0] else {
                        self.didFail(with: "New post not found.")
                        return
                }
                
                self.didSucceed(with: post, and: user)
            })
        }
    }
    
    func didFail(with message: String) {
        print("Write post did fail:", message)
        presenter.dismiss()
    }
    
    func didSucceed(with post: Post, and user: User) {
        print("Write post did succeed.")
        print("post:", post)
        print("user:", user)
        presenter.dismiss()
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
