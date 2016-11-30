//
//  CommentController.swift
//  Photostream
//
//  Created by Mounir Ybanez on 30/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class CommentController: UIViewController {

    var root: RootWireframe?
    var postId: String!
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor.white
        
        title = "Comments"
        
        let barItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(self.back))
        navigationItem.leftBarButtonItem = barItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        addCommentFeedModule()
        addCommentWriterModule()
    }
    
    func back() {
       let _ = navigationController?.popViewController(animated: true)
    }
    
    func addCommentWriterModule() {
        let module = CommentWriterModule()
        module.build(root: root, postId: postId)
        
        guard let controller = module.view.controller else {
            return
        }
        
        let height = controller.view.frame.size.height
        controller.view.frame.origin.y = view.frame.size.height - height
        controller.view.frame.size.width = view.frame.size.width
        addModuleView(controller)
    }
    
    func addCommentFeedModule() {
        let module = CommentFeedModule()
        module.build(root: root, postId: postId)
        
        guard let controller = module.view.controller else {
            return
        }
        
        controller.view.frame.origin = .zero
        controller.view.frame.size = view.frame.size
        addModuleView(controller)
    }
    
    func addModuleView(_ controller: UIViewController) {
        
        view.addSubview(controller.view)
        addChildViewController(controller)
        controller.didMove(toParentViewController: self)
    }
}
