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
    var presenter: PostUploadModuleInterface! { set get }
    
    func show(image: UIImage)
    
    func didFail(with message: String)
    func didSucceed()
    func didUpdate(with progress: Progress)
}
