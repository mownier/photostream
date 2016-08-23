//
//  CommentWireframe.swift
//  Photostream
//
//  Created by Mounir Ybanez on 23/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class CommentWireframe: AnyObject {

    var rootWireframe: RootWireframe!

    func navigateCommentInterfaceFromViewController(viewController: UIViewController, shouldComment: Bool) {
        let sb = UIStoryboard(name: "CommentModuleStoryboard", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("CommentsViewController") as! CommentsViewController
        vc.shouldComment = shouldComment
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
}
