//
//  NewsFeedModuleExtension.swift
//  Photostream
//
//  Created by Mounir Ybanez on 29/10/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

extension NewsFeedWireframe {
    
    static var viewController: NewsFeedViewController {
        let sb = UIStoryboard(name: "NewsFeedModuleStoryboard", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "NewsFeedViewController")
        return vc as! NewsFeedViewController
    }
}
