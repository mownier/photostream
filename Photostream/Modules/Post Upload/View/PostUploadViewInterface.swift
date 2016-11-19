//
//  PostUploadViewInterface.swift
//  Photostream
//
//  Created by Mounir Ybanez on 19/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

protocol PostUploadViewInterface: class {

    var controller: UIViewController? { get }
    
    func show(content: String)
    func show(image: UIImage)
    
    func didFail(with message: String)
    func didSucceed()
}
