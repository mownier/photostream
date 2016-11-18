//
//  PhotoSharePresenterInterface.swift
//  Photostream
//
//  Created by Mounir Ybanez on 18/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

protocol PhotoSharePresenterInterface: class {

    var view: PhotoShareViewInterface! { set get }
    var wireframe: PhotoShareWireframeInterface! { set get }
}
