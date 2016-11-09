//
//  PostComposerModuleExtension.swift
//  Photostream
//
//  Created by Mounir Ybanez on 09/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

extension PostComposerPresenter {
    
    var router: PostComposerWireframe? {
        return wireframe as? PostComposerWireframe
    }
}

extension PostComposerWireframe {
    
    class func createViewController() -> PostComposerViewController {
        let sb = UIStoryboard(name: "PostComposerModuleStoryboard", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "PostComposerViewController")
        return vc as! PostComposerViewController
    }
    
    class func createNavigationController() -> UINavigationController {
        let sb = UIStoryboard(name: "PostComposerModuleStoryboard", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "PostComposerNavigationController")
        return vc as! UINavigationController
    }
}
