//
//  CommentController.swift
//  Photostream
//
//  Created by Mounir Ybanez on 30/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

protocol CommentControllerInterface: BaseModuleWireframe {
    
    var postId: String! { set get }
    var feed: CommentFeedPresenter! { set get }
    var writer: CommentWriterPresenter! { set get }
    
    func setupFeed()
    func setupWriter()
}

extension CommentControllerInterface {
    
    func setupModules() {
        setupFeed()
        setupWriter()
    }
}

class CommentController: UIViewController, CommentControllerInterface {

    var style: WireframeStyle!
    var root: RootWireframe?
    var postId: String!
    
    var feed: CommentFeedPresenter!
    var writer: CommentWriterPresenter!
    var bottomInset: CGFloat {
        return writer.view.controller!.view.frame.size.height
    }
    
    required convenience init(root: RootWireframe?) {
        self.init()
        self.root = root
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor.white
        
        title = "Comments"
        
        let barItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(self.back))
        navigationItem.leftBarButtonItem = barItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        setupModules()
        
        let feedViewController = feed.view.controller!
        let writerViewFrame = writer.view.controller!.view.frame
        feedViewController.view.frame.size.height -= writerViewFrame.size.height
    }
    
    func back() {
        var property = WireframeExitProperty()
        property.controller = self
        exit(with: property)
    }
    
    func setupFeed() {
        let module = CommentFeedModule()
        module.build(root: root, postId: postId)
        module.wireframe.style = .attach
        feed = module.presenter
        
        let controller = module.view.controller!
        controller.view.frame.origin = .zero
        controller.view.frame.size = view.frame.size
        
        var property = WireframeEntryProperty()
        property.controller = controller
        property.parent = self
        
        module.wireframe.enter(with: property)
    }
    
    func setupWriter() {
        let module = CommentWriterModule()
        module.build(root: root, postId: postId)
        module.wireframe.style = .attach
        module.presenter.delegate = self
        writer = module.presenter
        
        let controller = module.view.controller!
        let height = controller.view.frame.size.height
        controller.view.frame.origin.y = view.frame.size.height - height
        controller.view.frame.size.width = view.frame.size.width
        
        var property = WireframeEntryProperty()
        property.controller = controller
        property.parent = self
        
        module.wireframe.enter(with: property)
    }
}

extension CommentController: CommentWriterDelegate {
    
    func commentWriterDidFinish(with comment: CommentWriterData?) {
        guard let newComment = comment as? CommentFeedData else {
            return
        }
        
        feed.comments.insert(newComment, at: 0)
        feed.view.hideRefreshView()
        feed.view.hideEmptyView()
        feed.view.hideInitialLoadView()
        feed.view.reload()
    }
    
    func keyboardWillMoveDown(with delta: KeyboardFrameDelta) {
        guard delta.height == 0 else {
            return
        }
        
        feed.view.adjust(bottomInset: -bottomInset)
    }
    
    func keyboardWillMoveUp(with delta: KeyboardFrameDelta) {
        guard delta.height == 0 else {
            return
        }
        
        feed.view.adjust(bottomInset: bottomInset)
    }
}
