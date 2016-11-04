//
//  NewsFeedWireframeInterface.swift
//  Photostream
//
//  Created by Mounir Ybanez on 29/10/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

protocol NewsFeedWireframeInterface: class {

    var root: RootWireframeInterface? { set get }
    
    init(root: RootWireframeInterface?, view: NewsFeedViewInterface)
    
    func attachRoot(with controller: UIViewController, in window: UIWindow)
}
