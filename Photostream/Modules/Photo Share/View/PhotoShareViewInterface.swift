//
//  PhotoShareViewInterface.swift
//  Photostream
//
//  Created by Mounir Ybanez on 18/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

protocol PhotoShareViewInterface: class {
    
    var controller: UIViewController? { get }
    var presenter: PhotoShareModuleInterface! { set get }
    var image: UIImage! { set get }
}
